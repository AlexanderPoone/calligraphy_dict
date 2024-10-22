## Dataset: Han characters which are often seen on r/translator subreddit
Novel task yet to be solved by machine learning?
### Algorithm Challenges
1. Skeletonisation... alright! But after junctions it is sometimes hard to determine which stroke is which? Are they counted as the same or separate strokes?
  * Vectorisation of skeletons to an ***order set of cubic Bezier curves*** - relatively easy - done.
  * Issue #1: Zooming out creates islands.
  * Issue #2: Machine learning may be needed to group the strokes. Zooming out affects whether vectorisation treating strokes as one or two.
  * => <ins>TRY USING STYLE-TRANSFER GAN for skeletonisation task ?!!</ins>
2. At least it can count the number of strokes, and compare results with the ground truth.
3. Indeed, there are virtually infinite variants, but OCR of cursive characters will be very helpful.
4. Once we've obtained the correct skeletonisation, how can we transform them into fill animations? We want After Effects-style animations so we can export them to Lottie, to use it on Android and iOS!
   * Import coordinates of the ordered set of splines into After Effects: to enumerate them + move along the strokes

### Interface TODOs
1. Port to Flutter for better cross-platform maintenance (30% done) (replace [these](Calligraphy%20Dictionary/Podfile) libraries)
2. For stroke order animations: Skeletonise characters -> split into strokes (half done) ~~https://stackoverflow.com/questions/62949339/how-to-draw-a-curve-like-this-in-uibezierpath-swift Draw `UIBezierPath` on CoreAnimation `CAShapeLayer`~~ Use Lottie
3. We need more samples, the target would be ~10,000.
