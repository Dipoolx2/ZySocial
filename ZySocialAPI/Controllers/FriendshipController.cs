using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Infrastructure;
using Microsoft.EntityFrameworkCore;
using NuGet.Protocol.Plugins;
using ZySocialAPI.Data;
using ZySocialAPI.Models;
using ZySocialAPI.Models.Custom;

namespace ZySocialAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class FriendshipController : ControllerBase
    {
        private ZySocialDbContext _context;
        public FriendshipController(ZySocialDbContext context)
        {
            this._context = context;
        }

        [HttpGet("[action]/{friendRequestId}")]
        public async Task<IActionResult> GetSimpleFriendRequest(Int64 friendRequestId)
        {
            var friendRequest = await _context.FriendRequests.FindAsync(friendRequestId);

            if (friendRequest == null)
            {
                return NotFound();
            }

            var simpleFriendRequest = new SimpleFriendRequest(friendRequest);

            return Ok(simpleFriendRequest);
        }

        [HttpGet("[action]/{userId}")]
        public async Task<IActionResult> GetSimpleFriendships(Int64 userId)
        {
            try
            {
                var friendRequests = await _context.FriendRequests
                    .Where(fr => (fr.UserSenderId == userId || fr.UserReceiverId == userId) && fr.Accepted && fr.Responded)
                    .Select(fr => new SimpleFriendRequest(fr))
                    .ToListAsync();

                if (friendRequests == null)
                {
                    return NotFound();
                }

                return Ok(friendRequests);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500, "A server-side error occurred.");
            }
        }

        [HttpGet("[action]/{userId}")]
        public async Task<IActionResult> GetFriends(Int64 userId)
        {
            try
            {
                var friendRequests = await _context.FriendRequests
                    .Where(fr => (fr.UserSenderId == userId || fr.UserReceiverId == userId) && fr.Accepted && fr.Responded)
                    .ToListAsync();

                var friendUserIds = friendRequests.Select(fr => fr.UserSenderId == userId ? fr.UserReceiverId : fr.UserSenderId).ToList();

                var friends = new List<SimpleUser>();
                foreach (var friendUserId in friendUserIds)
                {
                    try
                    {
                        var friend = await _context.Users
                            .Where(u => u.UserId == friendUserId)
                            .Select(u => new SimpleUser(u))
                            .FirstOrDefaultAsync();

                        if (friend == null)
                        {
                            continue;
                        }

                        friends.Add(friend);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                        continue;
                    }
                    
                }

                return Ok(friends);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500, "A server-side error occurred.");
            }
        }

        [HttpGet("[action]/{userId}")]
        public async Task<IActionResult> GetIncomingSimpleFriendRequests(Int64 userId)
        {
            try
            {
                var incomingFriendRequests = await _context.FriendRequests
                    .Where(fr => fr.UserReceiverId == userId && !fr.Responded && !fr.Accepted)
                    .Select(fr => new SimpleFriendRequest(fr))
                    .ToListAsync();

                return Ok(incomingFriendRequests);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500, "A server-side error occurred.");
            }
        }

        [HttpGet("[action]")]
        public async Task<IActionResult> GetSimpleFriendRequests()
        {
            try
            {
                var friendRequests = await _context.FriendRequests
                    .Select(fr => new SimpleFriendRequest(fr))
                    .ToListAsync();

                if (friendRequests == null)
                {
                    return NotFound();
                }

                return Ok(friendRequests);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500, "A server-side error occurred.");
            }
        }

        [HttpPost("[action]/{senderId}")]
        public async Task<IActionResult> SendFriendRequest(Int64 senderId, Int64 receiverId)
        {
            if (_context.Users == null)
            {
                return Problem("Entity set 'ZySocialDbContext.Users' is null.");
            }

            FriendRequest newFriendRequest = new FriendRequest();
            newFriendRequest.UserSenderId = senderId;
            newFriendRequest.UserReceiverId = receiverId;
            newFriendRequest.Accepted = false;
            newFriendRequest.Responded = false;
            newFriendRequest.SendDate = DateTime.Now;

            _context.FriendRequests.Add(newFriendRequest);

            try
            {
                await _context.SaveChangesAsync();

            }
            catch (DbUpdateException ex)
            {
                if (FriendRequestExists(newFriendRequest.FriendRequestId))
                {
                    return Conflict();
                }
                else
                {
                    Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                    return StatusCode(500);
                }
            }

            SimpleFriendRequest returnRequest = new SimpleFriendRequest(newFriendRequest);
            if (returnRequest == null)
            {
                return NotFound();
            }

            return Ok(returnRequest);
        }

        [HttpPost("[action]/{senderId}/{receiverName}")]
        public async Task<IActionResult> SendFriendRequestToName(Int64 senderId, String receiverName)
        {
            if (_context.Users == null)
            {
                return Problem("Entity set 'ZySocialDbContext.Users' is null.");
            }

            User? receiver = await _context.Users
                .FirstOrDefaultAsync(u => u.Name == receiverName);

            if (receiver == null)
            {
                return NotFound("Receiver not found.");
            }

            FriendRequest newFriendRequest = new FriendRequest
            {
                UserSenderId = senderId,
                UserReceiverId = receiver.UserId,
                SendDate = DateTime.Now,
                Accepted = false,
                Responded = false
            };

            _context.FriendRequests.Add(newFriendRequest);
            await _context.SaveChangesAsync();

            return Ok(new SimpleUser(receiver));
        }


        [HttpPost("[action]")]
        public async Task<IActionResult> PostSimpleFriendRequest([FromBody]SimpleFriendRequest simpleFriendRequest)
        {
            if (_context.Users == null)
            {
                return Problem("Entity set 'ZySocialDbContext.Users' is null.");
            }

            FriendRequest newFriendRequest = new FriendRequest();
            newFriendRequest.UserSenderId = simpleFriendRequest.UserSenderId;
            newFriendRequest.UserReceiverId = simpleFriendRequest.UserReceiverId;
            newFriendRequest.Accepted = simpleFriendRequest.Accepted;
            newFriendRequest.Responded = simpleFriendRequest.Responded;
            newFriendRequest.SendDate = simpleFriendRequest.SendDate;

            _context.FriendRequests.Add(newFriendRequest);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException ex)
            {
                if (FriendRequestExists(newFriendRequest.FriendRequestId))
                {
                    return Conflict();
                }
                else
                {
                    Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                    return StatusCode(500);
                }
            }

            var createdFriendRequest = await GetSimpleFriendRequest(newFriendRequest.FriendRequestId) as OkObjectResult;
            if (createdFriendRequest == null)
            {
                Console.WriteLine("ERROR: Newly created friend request with id " + newFriendRequest.FriendRequestId + " could not be found.");
                return StatusCode(500, "Newly created friend request could not be found.");
            }
            return createdFriendRequest;
        }

        [HttpPut("[action]/{requestId}/{accepted}")]
        public async Task<IActionResult> HandleSimpleFriendRequest(Int64 requestId, bool accepted)
        {
            var existingFriendRequest = await _context.FriendRequests.FindAsync(requestId);

            if (existingFriendRequest == null)
            {
                return NotFound();
            }

            existingFriendRequest.Accepted = accepted;
            existingFriendRequest.Responded = true;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException ex)
            {
                if (!FriendRequestExists(requestId))
                {
                    return NotFound();
                }
                else
                {
                    Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                    return StatusCode(500);
                }
            }

            var updatedFriendRequest = await GetSimpleFriendRequest(existingFriendRequest.FriendRequestId) as OkObjectResult;
            if (updatedFriendRequest == null)
            {
                return StatusCode(500, "Updated friend request could not be found.");
            }
            try
            {
                var user = await _context.Users
                    .Where(u => u.UserId == existingFriendRequest.UserSenderId)
                    .Select(u => new SimpleUser(u))
                    .FirstOrDefaultAsync();

                if (user == null)
                {
                    return NotFound();
                }

                return Ok(user);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500);
            }
        }

        private bool FriendRequestExists(Int64? id)
        {
            return (_context.FriendRequests?.Any(e => e.FriendRequestId == id)).GetValueOrDefault();
        }


        [HttpPut("[action]/{friendRequestId}")]
        public async Task<IActionResult> UpdateSimpleFriendRequest(Int64 friendRequestId, [FromBody] SimpleFriendRequest friendRequest)
        {
            var existingFriendRequest = await _context.FriendRequests.FindAsync(friendRequestId);

            if (existingFriendRequest == null)
            {
                return NotFound();
            }

            existingFriendRequest.UserSenderId = friendRequest.UserSenderId;
            existingFriendRequest.UserReceiverId = friendRequest.UserReceiverId;
            existingFriendRequest.Accepted = friendRequest.Accepted;
            existingFriendRequest.Responded = friendRequest.Responded;
            existingFriendRequest.SendDate = friendRequest.SendDate;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException ex)
            {
                if (!FriendRequestExists(friendRequestId))
                {
                    return NotFound();
                }
                else
                {
                    Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                    return StatusCode(500);
                }
            }

            var updatedFriendRequest = await GetSimpleFriendRequest(existingFriendRequest.FriendRequestId) as OkObjectResult;
            if (updatedFriendRequest == null)
            {
                return StatusCode(500, "Updated friend request could not be found.");
            }
            return updatedFriendRequest;
        }

        [HttpDelete("[action]/{friendRequestId}")]
        public async Task<IActionResult> DeleteFriendRequest(Int64 friendRequestId)
        {
            try
            {
                var friendRequest = await _context.FriendRequests.FindAsync(friendRequestId);

                if (friendRequest == null)
                {
                    return NotFound();
                }

                _context.FriendRequests.Remove(friendRequest);
                await _context.SaveChangesAsync();

                return Ok();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500);
            }

        }

        [HttpDelete("[action]/{userId}")]
        public async Task<IActionResult> DeletePotentialFriendRequests(Int64 userId, Int64 friendId)
        {
            try
            {
                List<FriendRequest> friendRequests = await _context.FriendRequests
                    .Where(fr => (fr.UserSenderId == userId && fr.UserReceiverId == friendId) || (fr.UserSenderId == friendId && fr.UserReceiverId == userId))
                    .ToListAsync();

                foreach (FriendRequest fr in friendRequests)
                {
                    _context.FriendRequests.Remove(fr);
                }

                await _context.SaveChangesAsync();

                return Ok();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500, "A server-side error occurred.");
            }
        }


    }
}
