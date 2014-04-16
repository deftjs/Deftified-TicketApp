Deftified-TicketApp
===================

Development
===========

Install `gulp` globally:

    npm install -g gulp

Install Cmd by downloading Sencha CMd.

Pull down submodules:

    git submodule init && git submodule update

Install `gulp` modules:

    npm install

Compile coffeescript:

    gulp [watch]

Build the app:

    cd app/ticket-app && sencha app build && cd - 
