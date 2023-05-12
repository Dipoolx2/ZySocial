using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZySocialAPI.Data;
using ZySocialAPI.Models.Custom;

namespace ZySocialAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CommentController : ControllerBase
    {
        private ZySocialDbContext _context;
        public CommentController(ZySocialDbContext context) {
            this._context = context;
        }

        [HttpGet("[action]")]
        public async Task<IActionResult> GetSimpleComments()
        {
            try
            {
                var commments = await _context.Comments.Select(c => new SimpleComment
                {
                    UserId = c.UserId,
                    CommentId = c.CommentId,
                    PostId = c.PostId,
                    Body = c.Body,
                }).ToListAsync();

                if (commments == null)
                {
                    return NotFound();
                }
                return Ok(commments);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500, "A server-side error occurred.");
            }
        }

    }
}
