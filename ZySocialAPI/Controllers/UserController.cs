using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZySocialAPI.Data;
using ZySocialAPI.Models;
using ZySocialAPI.Models.Custom;

namespace ZySocialAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserController : Controller
    {
        private ZySocialDbContext _context;
        public UserController(ZySocialDbContext context) {
            this._context = context;
        }

        [HttpGet("[action]")]
        public async Task<ActionResult<IEnumerable<SimpleUser>>> GetSimpleUsers()
        {
            var users = _context.Users.Select(u => new SimpleUser
            {
                UserId = u.UserId,
                Name = u.Name,
                Password = u.Password,
                Email = u.Email,
                PhoneNumber = u.PhoneNumber,
                ProfilePicture = u.ProfilePicture
            }).ToList();

            if (users == null)
            {
                return NotFound();
            }

            return Ok(users);
        }

    }
}
