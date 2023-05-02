using System;
using System.Collections.Generic;

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

        public long UserId { get; set; }
        public string Name { get; set; } = null!;
        public string Password { get; set; } = null!;
        public string? Email { get; set; }
        public string? PhoneNumber { get; set; }
        public string ProfilePicture { get; set; } = null!;

        public virtual ICollection<Comment> Comments { get; set; }
        public virtual ICollection<FriendRequest> FriendRequestUserReceivers { get; set; }
        public virtual ICollection<FriendRequest> FriendRequestUserSenders { get; set; }
        public virtual ICollection<Notification> Notifications { get; set; }
        public virtual ICollection<Post> Posts { get; set; }
    }
}
