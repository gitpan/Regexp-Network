use ExtUtils::MakeMaker;
WriteMakefile(
    NAME		=> 'Regexp::Network',
    VERSION_FROM	=> 'lib/Regexp/Network.pm',
    PREREQ_PM => {
		'Carp' => 0,
		'Module::Info' => 0.12,
		'Test::More' => 0.42,
		'Memoize' => 1.00,
		'Exporter' => 5.562,
	    },
        ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/Regexp/Network.pm', # retrieve abstract from module
      AUTHOR     => 'Iain Truskett <spoon@cpan.org>') : ()),
);


