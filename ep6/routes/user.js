var db = require('../models')

exports.signUp = function(req, res) {
	res.render("signup.ejs");
}

exports.register = function(req, res){
	db.User.find({where: {username: req.username}}).success(function (user){
		if(!user) {
			db.User.create({username: req.body.username, password: req.body.password}).error(function(err){
				console.log(err);
			});
		} else {
			res.redirect('/signup')
		}
	})
	res.redirect('/')
};

exports.update = function(req, res) {
	var t = function(cb, user) {
    	if (user) {
		 req.user.password = req.body.new_password
		 req.user.save()
	   }
	}
	if (req.body.new_password = req.body.new_password_confirmation){
		db.User.validPassword(req.body.current_password, req.user.password, t, req.user)
	}
  
    res.redirect('/account')
};