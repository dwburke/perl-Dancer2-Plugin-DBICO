
use Test::Spec; # automatically turns on strict and warnings
use FindBin;
use lib "$FindBin::Bin/../lib";

use Dancer2::Plugin::DBICO;

describe "Dancer2::Plugin::DBICO" => sub {

    it "workse" => sub {
        ok(1);
    };

};

runtests unless caller;

