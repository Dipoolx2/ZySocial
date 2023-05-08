using System;
using System.Collections.Generic;

namespace ZySocialAPI.Models
{
    public partial class Comment
    {
        public Int64 CommentId { get; set; }
        public Int64 PostId { get; set; }
        public String Body { get; set; } = null!;
        public Int64 UserId { get; set; }

        public virtual Post Post { get; set; } = null!;
        public virtual User User { get; set; } = null!;
    }
}
