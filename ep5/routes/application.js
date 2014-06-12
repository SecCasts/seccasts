exports.IsAuthenticated = function(req, res, next){
	if(req.isAuthenticated()){
		next();
	} else {
		next(new Error(401));
	}
}

exports.destroySession = function(req, res, next) {
	req.logOut();
	req.session.destroy()
	res.redirect("/")
}