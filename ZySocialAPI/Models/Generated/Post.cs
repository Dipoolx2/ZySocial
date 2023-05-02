using System;
using System.Collections.Generic;

namespace ZySocialAPI.Models
{
    public partial class Post
    {
        public Post()
        {
            Comments = new HashSet<Comment>();
        }

        public long PostId { get; set; }
        public long UserId { get; set; }
        public string? Image { get; set; }
        public string Caption { get; set; } = null!;
        public bool ShowLikes { get; set; }
        public bool AllowComments { get; set; }
        public int LikeCount { get; set; }
        public DateTime PostDate { get; set; }

        public virtual User User { get; set; } = null!;
        public virtual ICollection<Comment> Comments { get; set; }
    }
}
