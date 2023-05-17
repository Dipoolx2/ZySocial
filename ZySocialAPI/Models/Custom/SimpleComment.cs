namespace ZySocialAPI.Models.Custom
{
    public class SimpleComment
    {
        public SimpleComment(Comment c)
        {
            this.CommentId = c.CommentId;
            this.PostId = c.PostId;
            this.Body = c.Body;
            this.UserId = c.UserId;
        }

        public Int64 CommentId { get; set; }
        public Int64 PostId { get; set; }
        public String Body { get; set; } = null!;
        public Int64 UserId { get; set; }
    }
}
