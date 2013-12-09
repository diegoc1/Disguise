MOTIVATION: Say you are at a restuarant with a bunch of friends, and you want to split the cost of the bill.  It's often difficult to calculate how much each person owns, so we created an app to simplify that process.  

HOW TO USE:
1) Take a photo of a receipt
2) Crop the photo so that you only the receipt appears in the image (now background is showing)
3) Our backend will read in the lines of the receipt
4) A view controller will be displayed to you that allows you to select the items that you purchased
5) You can press "Set Tip" to set the tip amount
6) You can swipe right on a table cell to edit it's contents
7) You can swupe left on a table cell to delete it
6) You press checkout when you are done selecting your items
7) From here, you can see your total and you choose to save your image
8) If you press save, you will be taken to a view controller that prompts you for a title
9) Once you press save, the receipt will be saved using CoreData

MAPS:
The maps tab displays pins for the locations where you took pictures of receipts.  You can click on a pin to display the contents of that receipt.

HISTORY:
This tab contains a list of all the receipts you have saved.  You can click on a receipt to display its contents.  From here you can choose to send an email, send a text, post to facebook, or post to twitter
