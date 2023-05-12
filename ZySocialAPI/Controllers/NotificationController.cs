using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZySocialAPI.Data;
using ZySocialAPI.Models;
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

        [HttpPost("[action]")]
        public async Task<IActionResult> PostSimpleNotification([FromBody] SimpleNotification simpleNotification)
        {
            if (_context.Users == null)
            {
                return Problem("Entity set 'ZySocialDbContext.Users' is null.");
            }

            Notification newNotification = new Notification();
            newNotification.UserId = simpleNotification.UserId;
            newNotification.Title = simpleNotification.Title;
            newNotification.Body = simpleNotification.Body;

            _context.Notifications.Add(newNotification);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException ex)
            {
                if (NotificationExists(newNotification.NotificationId))
                {
                    return Conflict();
                }
                else
                {
                    Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                    return StatusCode(500); ;
                }
            }

            var createdNotification = await GetSimpleNotification(newNotification.NotificationId) as OkObjectResult;
            if (createdNotification == null) 
            {
                Console.WriteLine("ERROR: Newly created notification with id " + newNotification.NotificationId + " could not be found.");
                return StatusCode(500, "Newly created notification could not be found.");
            }
            return createdNotification;
        }

        [HttpPut("[action]/{notificationId}")]
        public async Task<IActionResult> UpdateSimpleNotification(Int64 notificationId, [FromBody] SimpleNotification notification)
        {
            var existingNotification = await _context.Notifications.FindAsync(notificationId);

            if (existingNotification == null)
            {
                return NotFound();
            }

            existingNotification.UserId = notification.UserId;
            existingNotification.Title = notification.Title;
            existingNotification.Body = notification.Body;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException ex)
            {
                if (!NotificationExists(notificationId))
                {
                    return NotFound();
                }
                else
                {
                    Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                    return StatusCode(500);
                }
            }

            var updatedNotification = await GetSimpleNotification(existingNotification.NotificationId) as OkObjectResult;
            if (updatedNotification == null)
            {
                Console.WriteLine("ERROR: Updated notification with id " + existingNotification.NotificationId + " could not be found.");
                return StatusCode(500, "Updated notification could not be found.");
            }
            return updatedNotification;
        }

        [HttpGet("[action]/{notificationId}")]
        public async Task<IActionResult> GetSimpleNotification(Int64 notificationId)
        {
            var notification = await _context.Notifications.FindAsync(notificationId);

            if (notification == null)
            {
                return NotFound();
            }

            var simpleNotification = new SimpleNotification
            {
                UserId = notification.UserId,
                NotificationId = notification.NotificationId,
                Body = notification.Body,
                Title = notification.Title
            };

            return Ok(simpleNotification);
        }

        [HttpDelete("[action]/{notificationId}")]
        public async Task<IActionResult> DeleteSimpleNotification(Int64 notificationId)
        {
            try
            {
                var notification = await _context.Notifications.FindAsync(notificationId);

                if (notification == null)
                {
                    return NotFound();
                }

                _context.Notifications.Remove(notification);
                await _context.SaveChangesAsync();

                return Ok();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500);
            }
        }

        private bool NotificationExists(Int64? id)
        {
            return (_context.Notifications?.Any(e => e.NotificationId == id)).GetValueOrDefault();
        }
    }
}
