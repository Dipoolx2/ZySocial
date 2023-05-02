using System;
using System.Collections.Generic;

namespace ZySocialAPI.Models
{
    public partial class Comment
    {
        public long CommentId { get; set; }
        public long PostId { get; set; }
        public string Body { get; set; } = null!;
        public long UserId { get; set; }

        public virtual Post Post { get; set; } = null!;
        public virtual User User { get; set; } = null!;
    }
}
