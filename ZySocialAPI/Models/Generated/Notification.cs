using System;
using System.Collections.Generic;

namespace ZySocialAPI.Models
{
    public partial class Notification
    {
        public Int64 NotificationId { get; set; }
        public Int64 UserId { get; set; }
        public String Title { get; set; } = null!;
        public String? Body { get; set; }

        public virtual User User { get; set; } = null!;
    }
}
