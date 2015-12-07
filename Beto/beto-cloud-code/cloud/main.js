
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.job("cleanExpiredEvents", function(request, status){
  Parse.Cloud.useMasterKey();
  var rightNow = new Date().getTime();
  var query = new Parse.Query('Event');
        query.lessThan('expirationDate', rightNow);

        query.find().then(function (posts) {
            Parse.Object.destroyAll(posts, {
                success: function() {
                    status.success('All expired events are removed.');
                },
                error: function(error) {
                    status.error('Error, expired events are not removed.');
                }
            });
        }, function (error) {});
});
