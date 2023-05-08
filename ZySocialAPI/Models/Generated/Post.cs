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

        public Int64 PostId { get; set; }
        public Int64 UserId { get; set; }
        public String? Image { get; set; }
        public String Caption { get; set; } = null!;
        public bool ShowLikes { get; set; }
        public bool AllowComments { get; set; }
        public Int64 LikeCount { get; set; }
        public DateTime PostDate { get; set; }

        public virtual User User { get; set; } = null!;
        public virtual ICollection<Comment> Comments { get; set; }
    }
}
