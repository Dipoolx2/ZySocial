using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Infrastructure;
using Microsoft.EntityFrameworkCore;
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

            var simpleFriendRequest = new SimpleFriendRequest
            {
                UserSenderId = friendRequest.UserSenderId,
                UserReceiverId = friendRequest.UserReceiverId,
                Accepted = friendRequest.Accepted,
                Responded = friendRequest.Responded,
                FriendRequestId = friendRequest.FriendRequestId,
                SendDate = friendRequest.SendDate
            };

            return Ok(simpleFriendRequest);
        }


        [HttpGet("[action]")]
        public async Task<IActionResult> GetSimpleFriendRequests()
        {
            try
            {
                var friendRequests = await _context.FriendRequests
                    .Select(fr => new SimpleFriendRequest
                    {
                        UserSenderId = fr.UserSenderId,
                        UserReceiverId = fr.UserReceiverId,
                        Accepted = fr.Accepted,
                        Responded = fr.Responded,
                        FriendRequestId = fr.FriendRequestId,
                        SendDate = fr.SendDate
                    })
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


    }
}
