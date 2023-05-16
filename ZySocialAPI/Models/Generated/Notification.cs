using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ZySocialAPI.Models
{
    public partial class Notification
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int64 NotificationId { get; set; }
        public Int64 UserId { get; set; }
        public String Title { get; set; } = null!;
        public String? Body { get; set; }

        public virtual User User { get; set; } = null!;
    }
}
