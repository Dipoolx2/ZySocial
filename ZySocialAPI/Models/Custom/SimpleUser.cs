namespace ZySocialAPI.Models.Custom
{
    public class SimpleUser
    {
        public Int64? UserId { get; set; }
        public String Name { get; set; } = null!;
        public String Password { get; set; } = null!;
        public String? Email { get; set; }
        public String? PhoneNumber { get; set; }
        public String ProfilePicture { get; set; } = null!;
    }
}
