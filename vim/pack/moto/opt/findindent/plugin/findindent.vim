if exists("g:loaded_findindent") || &cp
    finish
endif

let g:loaded_findindent = 1

function! findindent#do()
perl << EOS
use lib "$ENV{HOME}/.vim/perl5/lib/perl5";
my $has_text_findindent = eval 'require Text::FindIndent; 1';
if($has_text_findindent) {
    require Text::FindIndent;
    my @cmd = do {
        my $doc = join "\n", $curbuf->Get( 1 .. $curbuf->Count );
        Text::FindIndent->to_vim_commands( $doc );
    };
    for ( @cmd ) {
        s{:set\b}{:setlocal};
        VIM::DoCommand $_;
    }
}
EOS
endfunction
