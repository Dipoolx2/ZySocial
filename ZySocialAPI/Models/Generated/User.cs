using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ZySocialAPI.Models
{
    public partial class User
    {
        public User()
        {
            Comments = new HashSet<Comment>();
            FriendRequestUserReceivers = new HashSet<FriendRequest>();
            FriendRequestUserSenders = new HashSet<FriendRequest>();
            Notifications = new HashSet<Notification>();
            Posts = new HashSet<Post>();
        }
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int64? UserId { get; set; }
        public String Name { get; set; } = null!;
        public String Password { get; set; } = null!;
        public String? Email { get; set; }
        public String? PhoneNumber { get; set; }
        public String ProfilePicture { get; set; } = null!;

        public virtual ICollection<Comment> Comments { get; set; }
        public virtual ICollection<FriendRequest> FriendRequestUserReceivers { get; set; }
        public virtual ICollection<FriendRequest> FriendRequestUserSenders { get; set; }
        public virtual ICollection<Notification> Notifications { get; set; }
        public virtual ICollection<Post> Posts { get; set; }
    }
}
