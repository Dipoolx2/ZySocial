namespace ZySocialAPI.Models.Custom
{
    public class SimpleUser
    {
        public SimpleUser(User user)
        {
            this.UserId = user.UserId;
            this.Name = user.Name;
            this.Password = user.Password;
            this.Email = user.Email;
            this.PhoneNumber = user.PhoneNumber;
            this.ProfilePicture = user.ProfilePicture;
        }

        public Int64 UserId { get; set; }
        public String Name { get; set; } = null!;
        public String Password { get; set; } = null!;
        public String? Email { get; set; }
        public String? PhoneNumber { get; set; }
        public String ProfilePicture { get; set; } = null!;
    }
}
