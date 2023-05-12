using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZySocialAPI.Data;
using ZySocialAPI.Models.Custom;

namespace ZySocialAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class NotificationController : Controller
    {
        private ZySocialDbContext _context;
        public NotificationController(ZySocialDbContext context)
        {
            this._context = context;
        }

        [HttpGet("[action]")]
        public async Task<IActionResult> GetSimpleNotifications()
        {
            try
            {
                var notifications = await _context.Notifications.Select(n => new SimpleNotification
                {
                    UserId = n.UserId,
                    NotificationId = n.NotificationId,
                    Body = n.Body,
                    Title = n.Title,
                }).ToListAsync();

                if (notifications == null)
                {
                    return NotFound();
                }
                return Ok(notifications);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500, "A server-side error occurred.");
            }
        }
    }
}
