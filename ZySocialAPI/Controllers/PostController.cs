using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZySocialAPI.Data;
using ZySocialAPI.Models.Custom;

namespace ZySocialAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PostController : ControllerBase
    {
        private ZySocialDbContext _context;
        public PostController(ZySocialDbContext context)
        {
            this._context = context;
        }

        [HttpGet("[action]")]
        public async Task<IActionResult> GetSimplePosts()
        {
            try
            {
                var posts = await _context.Posts.Select(p => new SimplePost
                {
                    UserId = p.UserId,
                    PostId = p.PostId,
                    Image = p.Image,
                    Caption = p.Caption,
                    ShowLikes = p.ShowLikes,
                    AllowComments = p.AllowComments,
                    LikeCount = p.LikeCount,
                    PostDate = p.PostDate
                }).ToListAsync();

                if (posts == null)
                {
                    return NotFound();
                }
                return Ok(posts);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500, "A server-side error occurred.");
            }

        }
    }
}
