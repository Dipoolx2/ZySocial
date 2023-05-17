namespace ZySocialAPI.Models.Custom
{
    public class SimplePost
    {
        public SimplePost(Post post)
        {
            this.PostId = post.PostId;
            this.UserId = post.UserId;
            this.Image = post.Image;
            this.Caption = post.Caption;
            this.ShowLikes = post.ShowLikes;
            this.AllowComments = post.AllowComments;
            this.LikeCount = post.LikeCount;
            this.PostDate = post.PostDate;
        }
        public Int64 PostId { get; set; }
        public Int64 UserId { get; set; }
        public String? Image { get; set; }
        public String Caption { get; set; } = null!;
        public bool ShowLikes { get; set; }
        public bool AllowComments { get; set; }
        public Int64 LikeCount { get; set; }
        public DateTime PostDate { get; set; }
    }
}
