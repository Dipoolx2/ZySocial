using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZySocialAPI.Data;
using ZySocialAPI.Models;
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

        [HttpGet("[action]/{commentId}")]
        public async Task<IActionResult> GetSimpleComment(Int64 commentId)
        {
            try
            {
                var comment = await _context.Comments.FindAsync(commentId);

                if (comment == null)
                {
                    return NotFound();
                }

                var simpleComment = new SimpleComment
                {
                    CommentId = comment.CommentId,
                    UserId = comment.UserId,
                    Body = comment.Body,
                    PostId = comment.PostId
                };

                return Ok(simpleComment);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500);
            }
        }

        [HttpDelete("[action]/{commentId}")]
        public async Task<IActionResult> DeleteComment(Int64 commentId)
        {
            try
            {
                var comment = await _context.Comments.FindAsync(commentId);

                if (comment == null)
                {
                    return NotFound();
                }

                _context.Comments.Remove(comment);
                await _context.SaveChangesAsync();

                return Ok();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500);
            }
        }

        [HttpPost("[action]")]
        public async Task<IActionResult> PostSimpleComment([FromBody] SimpleComment simpleComment)
        {
            if (_context.Users == null)
            {
                return Problem("Entity set 'ZySocialDbContext.Users' is null.");
            }

            Comment newComment = new Comment();
            newComment.UserId = simpleComment.UserId;
            newComment.Body = simpleComment.Body;
            newComment.PostId = simpleComment.PostId;

            _context.Comments.Add(newComment);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException ex)
            {
                if (CommentExists(newComment.CommentId))
                {
                    return Conflict();
                }
                else
                {
                    Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                    return StatusCode(500);
                }
            }

            var createdComment = await GetSimpleComment(newComment.CommentId) as OkObjectResult;
            if (createdComment == null)
            {
                Console.WriteLine("ERROR: Newly created comment with id " + newComment.CommentId + " could not be found.");
                return StatusCode(500, "Newly created comment could not be found.");
            }
            return createdComment;
        }

        [HttpPut("[action]/{commentId}")]
        public async Task<IActionResult> UpdateSimpleComment(Int64 commentId, [FromBody] SimpleComment comment)
        {
            var existingComment = await _context.Comments.FindAsync(commentId);

            if (existingComment == null)
            {
                return NotFound();
            }

            existingComment.UserId = comment.UserId;
            existingComment.Body = comment.Body;
            existingComment.PostId = comment.PostId;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException ex)
            {
                if (!CommentExists(commentId))
                {
                    return NotFound();
                }
                else
                {
                    Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                    return StatusCode(500);
                }
            }

            var updatedComment = await GetSimpleComment(existingComment.CommentId) as OkObjectResult;
            if (updatedComment == null)
            {
                Console.WriteLine("ERROR: Updated comment with id " + existingComment.CommentId + " could not be found.");
                return StatusCode(500, "Updated comment could not be found.");
            }
            return updatedComment;
        }

        private bool CommentExists(Int64? id)
        {
            return (_context.Comments?.Any(e => e.CommentId == id)).GetValueOrDefault();
        }
    }
}
