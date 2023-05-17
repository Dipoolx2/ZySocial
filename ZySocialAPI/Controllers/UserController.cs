using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Permissions;
using System.Text.RegularExpressions;
using ZySocialAPI.Data;
using ZySocialAPI.Models;
using ZySocialAPI.Models.Custom;

namespace ZySocialAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserController : ControllerBase
    {
        private ZySocialDbContext _context;
        public UserController(ZySocialDbContext context) {
            this._context = context;
        }

        [HttpGet("[action]")]
        public async Task<IActionResult> GetSimpleUsers()
        {
            try
            {
                var users = await _context.Users.Select(u => new SimpleUser(u)).ToListAsync();

                if (users == null)
                {
                    return NotFound();
                }
                return Ok(users);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500);
            }
            
        }

        [HttpPost("[action]")]
        public async Task<IActionResult> PostSimpleUser(SimpleUser user)
        {
            if (_context.Users == null)
            {
                return Problem("Entity set 'ZySocialDbContext.Users' is null.");
            }

            User newUser = new User();
            newUser.Name = user.Name;
            newUser.Password = user.Password;
            newUser.Email = user.Email;
            newUser.PhoneNumber = user.PhoneNumber;
            newUser.ProfilePicture = user.ProfilePicture;

            _context.Users.Add(newUser);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException ex)
            {
                if (UserExists(newUser.UserId))
                {
                    return Conflict();
                }
                else
                {
                    return StatusCode(500);
                }
            }

            var createdUser = await GetSimpleUser(newUser.UserId) as OkObjectResult;
            if (createdUser == null)
            {
                Console.WriteLine("ERROR: Newly created user with id " + newUser.UserId + " could not be found.");
                return StatusCode(500, "Newly created user could not be found.");
            }
            return createdUser;
        }

        [HttpPost("[action]/{username}/{password}/{email}")]
        public async Task<IActionResult> RegisterNewUser(string username, string password, string email)
        {
            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
            {
                return BadRequest("Invalid input");
            }

            bool usernameExists = await _context.Users.AnyAsync(u => u.Name == username);
            if (usernameExists)
            {
                return BadRequest("Username already taken");
            }

            bool emailExists = await _context.Users.AnyAsync(u => u.Email == email);
            if (emailExists)
            {
                return BadRequest("Email already taken");
            }

            User newUser = new User
            {
                Name = username,
                Password = password,
                Email = email,
                PhoneNumber = "",
                ProfilePicture = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"
            };

            _context.Users.Add(newUser);
            await _context.SaveChangesAsync();

            var updatedUser = await GetSimpleUser(newUser.UserId) as OkObjectResult;
            if (updatedUser == null)
            {
                Console.WriteLine("ERROR: Updated user with id " + newUser.UserId + " could not be found.");
                return StatusCode(500, "Updated user could not be found.");
            }

            return updatedUser;
        }


        [HttpGet("[action]/{userId}")]
        public async Task<IActionResult> GetSimpleUser(Int64 userId)
        {
            try
            {
                var user = await _context.Users
                    .Where(u => u.UserId == userId)
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

        [HttpPut("[action]/{userId}")]
        public async Task<IActionResult> UpdateSimpleUser(Int64 userId, [FromBody] SimpleUser user)
        {
            try
            {
                var existingUser = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userId);

                if (existingUser == null)
                {
                    return NotFound();
                }

                existingUser.Name = user.Name;
                existingUser.Password = user.Password;
                existingUser.Email = user.Email;
                existingUser.PhoneNumber = user.PhoneNumber;
                existingUser.ProfilePicture = user.ProfilePicture;

                await _context.SaveChangesAsync();

                var updatedUser = await GetSimpleUser(existingUser.UserId) as OkObjectResult;
                if (updatedUser == null)
                {
                    Console.WriteLine("ERROR: Updated user with id " + existingUser.UserId + " could not be found.");
                    return StatusCode(500, "Updated user could not be found.");
                }
                return updatedUser;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500);
            }
        }

        [HttpPut("[action]/{userId}/{email}")]
        public async Task<IActionResult> UpdateUserEmail(Int64 userId, String email)
        {
            try
            {
                bool emailExists = await _context.Users.AnyAsync(u => u.Email == email);
                if (emailExists)
                {
                    return BadRequest("Email already taken");
                }

                var existingUser = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userId);

                if (existingUser == null)
                {
                    return NotFound();
                }

                existingUser.Email = email;

                await _context.SaveChangesAsync();

                var updatedUser = await GetSimpleUser(existingUser.UserId) as OkObjectResult;
                if (updatedUser == null)
                {
                    Console.WriteLine("ERROR: Updated user with id " + existingUser.UserId + " could not be found.");
                    return StatusCode(500, "Updated user could not be found.");
                }
                return updatedUser;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500);
            }
        }

        [HttpPut("[action]/{userId}/{phoneNumber}")]
        public async Task<IActionResult> UpdateUserPhoneNumber(Int64 userId, String phoneNumber)
        {
            try
            {
                bool isNumeric = Regex.IsMatch(phoneNumber, @"^\d+$");
                if (!isNumeric)
                {
                    return BadRequest("Invalid input");
                }
                var existingUser = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userId);

                if (existingUser == null)
                {
                    return NotFound();
                }

                existingUser.PhoneNumber = phoneNumber;

                await _context.SaveChangesAsync();

                var updatedUser = await GetSimpleUser(existingUser.UserId) as OkObjectResult;
                if (updatedUser == null)
                {
                    Console.WriteLine("ERROR: Updated user with id " + existingUser.UserId + " could not be found.");
                    return StatusCode(500, "Updated user could not be found.");
                }
                return updatedUser;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500);
            }
        }

        [HttpDelete("[action]/{userId}")]
        public async Task<IActionResult> DeleteUser(Int64 userId)
        {
            try
            {
                var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userId);

                if (user == null)
                {
                    return NotFound();
                }

                _context.Users.Remove(user);
                await _context.SaveChangesAsync();

                return Ok();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + "\n" + ex.StackTrace);
                return StatusCode(500, "A server-side error occurred.");
            }
        }

        [HttpGet("[action]")]
        public async Task<ActionResult<UserId>> LoginSimpleUser(string username, string password)
        {
            if (String.IsNullOrWhiteSpace(username) || String.IsNullOrWhiteSpace(password))
            {
                return new UserId(-1);
            }
            try
            {
                var user = await _context.Users.FirstOrDefaultAsync(u => u.Password == password &&
                                                                         u.Name == username); 
                if (user == null)
                {
                    Console.WriteLine("User is null.");
                    return new UserId(-1);
                }
                return new UserId(user.UserId);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message + "\n" + e.StackTrace);
                return new UserId(-1);
            }
        }

        private bool UserExists(Int64? id)
        {
            return (_context.Users?.Any(e => e.UserId == id)).GetValueOrDefault();
        }
       
    }
}
