﻿using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query.SqlExpressions;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion.Internal;
using System.Globalization;
using ZySocialAPI.Data;
using ZySocialAPI.Models;
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
                var posts = await _context.Posts.Select(p => new SimplePost(p)).ToListAsync();

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

        [HttpPost("[action]/{userId}/{caption}/{image}/{likes}/{comments}")]
        public async Task<IActionResult> NewPost(Int64 userId, string caption, string? image, bool likes, bool comments)
        {
            if (_context.Users == null)
            {
                return Problem("Entity set 'ZySocialDbContext.Users' is null.");
            }

            Post newPost = new Post();
            newPost.UserId = userId;
            newPost.Image = (image == "null" ? null : "https://i.imgur.com/"+image);
            newPost.Caption = caption;
            newPost.ShowLikes = likes;
            newPost.AllowComments = comments;
            newPost.LikeCount = 0;
            string formattedDateTime = DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss");
            newPost.PostDate = DateTime.ParseExact(formattedDateTime, "yyyy-MM-ddTHH:mm:ss", CultureInfo.InvariantCulture);

            _context.Posts.Add(newPost);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException ex)
            {
                if (PostExists(newPost.PostId))
                {
                    return Conflict();
                }
                else
                {
                    Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                    return StatusCode(500);
                }
            }

            var createdPost = await GetSimplePost(newPost.PostId) as OkObjectResult;
            if (createdPost == null)
            {
                Console.WriteLine("ERROR: Newly created post with id " + newPost.PostId + " could not be found.");
                return StatusCode(500, "Newly created post could not be found.");
            }
            return createdPost;
        }

        [HttpGet("[action]/{userId}")]
        public async Task<IActionResult> GetUserPosts(Int64 userId)
        {
            try
            {
                var posts = await _context.Posts
                    .Where(p => p.UserId == userId)
                    .Select(p => new SimplePost(p))
                    .ToListAsync();

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

        [HttpPost("[action]")]
        public async Task<IActionResult> PostSimplePost([FromBody] SimplePost simplePost)
        {
            if (_context.Users == null)
            {
                return Problem("Entity set 'ZySocialDbContext.Users' is null.");
            }

            Post newPost = new Post();
            newPost.UserId = simplePost.UserId;
            newPost.Image = simplePost.Image;
            newPost.Caption = simplePost.Caption;
            newPost.ShowLikes = simplePost.ShowLikes;
            newPost.AllowComments = simplePost.AllowComments;
            newPost.LikeCount = simplePost.LikeCount;
            newPost.PostDate = simplePost.PostDate;

            _context.Posts.Add(newPost);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException ex)
            {
                if (PostExists(newPost.PostId))
                {
                    return Conflict();
                }
                else
                {
                    Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                    return StatusCode(500);
                }
            }

            var createdPost = await GetSimplePost(newPost.PostId) as OkObjectResult;
            if (createdPost == null)
            {
                Console.WriteLine("ERROR: Newly created post with id " + newPost.PostId + " could not be found.");
                return StatusCode(500, "Newly created post could not be found.");
            }
            return createdPost;
        }

        private bool PostExists(Int64? id)
        {
            return (_context.Posts?.Any(e => e.PostId == id)).GetValueOrDefault();
        }

        [HttpGet("[action]/{postId}")]
        public async Task<IActionResult> GetSimplePost(Int64 postId)
        {
            try
            {
                var post = await _context.Posts.FindAsync(postId);

                if (post == null)
                {
                    return NotFound();
                }

                var simplePost = new SimplePost(post);

                return Ok(simplePost);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message + "\n" + e.StackTrace);
                return StatusCode(500);
            }
        }

        [HttpDelete("[action]/{postId}")]
        public async Task<IActionResult> DeletePost(Int64 postId)
        {
            try
            {
                var post = await _context.Posts.FindAsync(postId);

                if (post == null)
                {
                    return NotFound();
                }

                _context.Posts.Remove(post);
                await _context.SaveChangesAsync();

                return Ok();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500);
            }
        }

        [HttpPut("[action]/{postId}")]
        public async Task<IActionResult> UpdateSimplePost(Int64 postId, [FromBody] SimplePost post)
        {
            var existingPost = await _context.Posts.FindAsync(postId);

            if (existingPost == null)
            {
                return NotFound();
            }

            existingPost.UserId = post.UserId;
            existingPost.Image = post.Image;
            existingPost.Caption = post.Caption;
            existingPost.ShowLikes = post.ShowLikes;
            existingPost.AllowComments = post.AllowComments;
            existingPost.LikeCount = post.LikeCount;
            existingPost.PostDate = post.PostDate;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException ex)
            {
                if (!PostExists(postId))
                {
                    return NotFound();
                }
                else
                {
                    Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                    return StatusCode(500);
                }
            }

            var updatedPost = await GetSimplePost(existingPost.PostId) as OkObjectResult;
            if (updatedPost == null)
            {
                Console.WriteLine("ERROR: Updated post with id " + existingPost.PostId + " could not be found.");
                return StatusCode(500, "Updated post could not be found.");
            }
            return updatedPost;
        }

    }
}
