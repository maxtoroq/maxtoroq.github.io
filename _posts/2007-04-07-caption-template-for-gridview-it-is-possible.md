---
title: "Caption Template for GridView: It is possible."
date: 2007-04-07 13:02:06 -0400
tags: [asp.net webforms]
originally_published_at: http://maxtoroq.wordpress.com/2007/04/07/caption-template-for-gridview-it-is-possible/
comments: off
---

On [this article][1] Dino Esposito shows us how to implement a caption template for the GridView control. However he uses a regular `<tr>` element, not the `<caption>` element. Here is how you can implement a real caption template for the GridView control.

```csharp
using System; 
using System.Collections; 
using System.Web.UI; 
using System.ComponentModel; 
using System.Web.UI.WebControls;    

public class MyGridView : GridView {    

   protected ITemplate _captionTemplate;    

   [PersistenceMode(PersistenceMode.InnerProperty), TemplateInstance(TemplateInstance.Single), Browsable(false)] 
   public ITemplate CaptionTemplate { get { return _captionTemplate; } set { _captionTemplate = value; } }    

   protected override int CreateChildControls(IEnumerable dataSource, bool dataBinding) {    

      int numRows = base.CreateChildControls(dataSource, dataBinding);    

      if ((CaptionTemplate != null && string.IsNullOrEmpty(Caption)) && this.Controls.Count != 0) { 
         CustomGridViewCaptionRow captionRow = new CustomGridViewCaptionRow(); 
         CustomGridViewCaptionCell captionCell = new CustomGridViewCaptionCell();    

         CaptionTemplate.InstantiateIn(captionCell); 
         captionRow.Controls.Add(captionCell);    

         this.Controls[0].Controls.AddAt(0, captionRow); 
      }    

      return numRows; 
   }    

   #region Nested Types    

   private class CustomGridViewCaptionRow : GridViewRow {    

      protected override HtmlTextWriterTag TagKey { get { return HtmlTextWriterTag.Caption; } }    

      public CustomGridViewCaptionRow() : base(-1, -1, DataControlRowType.Header, DataControlRowState.Normal) { } 
      protected override void AddAttributesToRender(HtmlTextWriter writer) { } 
   }    

   private class CustomGridViewCaptionCell : TableCell {    

      public override void RenderBeginTag(HtmlTextWriter writer) { } 
      public override void RenderEndTag(HtmlTextWriter writer) { } 
   }    

   #endregion 
}
```

[1]: http://msdn2.microsoft.com/en-us/library/aa479300.aspx
