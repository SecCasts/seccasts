var express = require('express')
 , routes = require('./routes')
 , app = express()
 , user = require('./routes/user')
 , db = require('./models')
 , http = require('http')
 , passport = require('passport')
 , passportConfig = require('./config/passport')
 , home = require('./routes/home')
 , application = require('./routes/application')

SALT_WORK_FACTOR = 12;

app.use('/public', express.static(__dirname+'/public'));

app.set('views', __dirname + '/views')

app.set('port', process.env.PORT || 3003)
app.use(express.urlencoded())
app.use(express.bodyParser())
app.use(express.cookieParser())
app.use(express.session({ secret: 'goatjsformakebettersecurity'}))
app.use(passport.initialize())
app.use(passport.session())
app.use(app.router)

if ('development' === app.get('env')) {
	app.use(express.errorHandler())
}

app.get('/', routes.index)
app.get('/home', application.IsAuthenticated, home.homepage)
app.post('/authenticate',
  passport.authenticate('local',{
	successRedirect: '/home',
	failureRedirect: '/'
  })
)
app.get('/logout', application.destroySession)
app.get('/signup', user.signUp)
app.post('/register', user.register)

db
  .sequelize
  .sync()
  .complete(function(err){
	if (err) {
		throw err[0]
	} else {
		db.User.find({where: {username: 'admin'}}).success(function (user){
			if (!user) {
				db.User.build({username: 'admin', password: 'admin'}).save();
			};
		});
		
		http.createServer(app).listen(app.get('port'), function(){
			console.log('Express is listening on port ' + app.get('port'))
		});
	}
})