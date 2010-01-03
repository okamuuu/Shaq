package MyApp::Web::Dispatcher;
use HTTPx::Dispatcher;

connect ''         => { controller => 'Home', action => 'index' };
connect 'hi'       => { controller => 'Home', action => 'hi' };
connect 'redirect' => { controller => 'Home', action => 'redirect' };
connect 'error'    => { controller => 'Home', action => 'error' };

1;
 
