exports.homepage = function(req, res){
	res.render("homepage.ejs", { myVar: req.user.username })
}

exports.account = function(req, res) {
	res.render("myAccount.ejs", { username: req.user.username })
}