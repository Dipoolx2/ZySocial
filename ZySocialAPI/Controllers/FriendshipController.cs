using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZySocialAPI.Data;
using ZySocialAPI.Models;
using ZySocialAPI.Models.Custom;

namespace ZySocialAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class FriendshipController : Controller
    {
        private ZySocialDbContext _context;
        public FriendshipController(ZySocialDbContext context)
        {
            this._context = context;
        }

        [HttpGet("[action]")]
        public async Task<ActionResult<IEnumerable<SimpleFriendRequest>>> GetSimpleFriendRequests()
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


    }
}
