# iOSPerformanceTips

A small example project to test out suggestions from the article [iOS Performance tips you probably didn't know (from an ex-Apple engineer)](https://www.fadel.io/blog/posts/ios-performance-tips-you-probably-didnt-know/).

**Questions? Comments?** Please check the epic warnings marked below, then tweet me at [@twostraws](https://twitter.com/twostraws).

The app has three tabs:

1. “Text” shows many labels, each with a random `UUID`. The you tap Hide all the labels have `isHidden` set to true. When you tap Clear, they are hidden then have their text set to `nil`. When you tap Reset, they have new UUIDs generated and are shown again.
2. “Cells” shows a table view of 1000 rows, where each one displays three random UUIDs. As you scroll cell reuse happens, but if you tap “Start clearing on endDisplaying” the cells have their text label cleared when they leave the screen.
3. “Tags” shows many UIViews embedded inside each other, each with a different tag. When you tap Find Tag the app attempts to find all the views using their unique tag, and prints out how long it took.

Please give the project a try and let me see what you think. **I encourage you to check my logic too** – I just put this together out of curiosity, and it’s entirely possible I screwed up and/or am misrepresenting the article author’s suggestions.

I ran it myself a few times, and my results are below. For reference, I was using an iPhone 11 Pro max running iOS 13.3.1, and the code was built using Xcode 11.3.1 with the default Swift toolchain.


## Hiding labels

Hiding vs clearing labels isn’t as simple as you might think – UIKit appears to be doing extra work on our behalf.

For example, if I tap Hide then Reset several times over (Hide > Reset > Hide > Reset > etc), the app moves between 39.6MB and 47.1MB). If I then tap Hide + Clear, the app moves back to 39.6MB, but if I tap Hide + Clear *again* – without first tapping Reset – memory drops down to 32.2MB.

It looks like UIKit effectively ignores the text change when the text is also being hidden, but if you do it in a later runloop (by tapping the button again or by uncommenting the `DispatchQueue.main.async` code) then you *do* save memory. So, if you want to clear the text to save some memory, please take care to verify it has actually worked.

Note: we’re only talking about 7MB of RAM, and that’s when hiding 100 labels at the same time. The difference is greater when using more complex labels: if you add an emoji in there the gap is larger. Curiously, UIKit seems to clear the RAM immediately even without the second press / `DispatchQueue.main.async`.



## Hiding labels in cells

Scrolling around in a table while clearing text might in theory save some RAM, but it’s at the expense of CPU time. Honestly, I couldn’t see much of a difference – both are screamingly fast and light on RAM.

Following the findings from above, if you have complex labels (emoji!) and your labels are more than one or two lines, you’ll probably find some small memory savings, but I’m not entirely convinced it’s worth the CPU cost. I guess it’s not exactly hard to do…


## viewWithTag()

**Warning:** Before you read the below, please understand that I’m not passing positive or negative judgement on the `viewWithTag()` method, I’m just testing it out from a performance perspective.

In my test I created 500 views of random colors, each embedded inside each other to create a tree. I then ran `viewWithTag()` to find views with tags 1 through 1000, which will find the views I created for the first 500 and will find nothing for the second 500 – UIKit is effectively being forced to do a frankly silly amount of work.

The result is that UIKit performs all 1000 searches in 0.082 seconds. Yes, that’s slow enough that it will cause your UI to drop frames, but this is also a pretty nasty test – we’re specifically searching for tags that don’t exist to simulate a worst-case scenario, and our view hierarchy is pretty packed.

If you try searching for just one non-existent tag, it takes just 0.000898 seconds – less than 1/1000th of a second. Yes, that’s a thousandth of a second you could be doing other work, but also a) most of the time your view will be found earlier because `viewWithTag()` will stop searching as soon as a matching view is found, and b) if a 1/1000th of a second operation is the heaviest stack trace you want to optimize, I’d suggest you probably aren’t using `viewWithTag()`.


## ⚠️ Epic warning

Again, I’d like to repeat the warning that this code was just put together out of curiosity, and might contain major logic errors and/or entirely misrepresent the suggestions made by the article’s author. 

Regardless of the results, it’s always fun to explore UIKit and see how it behaves. It’s a large, complex, and mature codebase, and as with any project that size it’s not easy to provide blanket advice that works for everyone.

The suggestions from the article are very interesting and definitely worth exploring – I’m grateful to the author for taking the time to share them with us! Even if you don’t find them beneficial to your projects, perhaps you’ll learn something new along the way 🙌
