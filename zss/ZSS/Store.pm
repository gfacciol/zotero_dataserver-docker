package ZSS::Store;

use strict;
use warnings;

use Digest::MD5 qw (md5_hex);
use File::Util qw(escape_filename);
use File::Path qw(make_path);

sub new {
  my $class = shift;

  # TODO: read from config
  my $self = {storagepath => shift};

  bless $self, $class;
}

sub get_path {
  my $self = shift;
  my $key = shift;

  my $dirname = md5_hex($key);

  my $dir = $self->{storagepath} . substr($dirname, 0, 1) . "/" . $dirname ."/";

  return $dir;
}

sub get_filename {
  my $self = shift;
  my $key = shift;

  return escape_filename($key, '_');
}

sub get_filepath {
  my $self = shift;
  my $key = shift;

  return $self->get_path($key) . $self->get_filename($key);
}

sub store_file {
  my $self = shift;
  my $key = shift;
  my $data = shift;
  my $meta = shift;

  my $dir = $self->get_path($key);
  my $file = $self->get_filename($key);

  make_path($dir);

  # Write data to temp file and rename to the desired name
  # This only changes this file and not other hardlinks
  open(my $fh, '>:raw', $dir.$file.".temp");
  print $fh ($data);
  close($fh);
  rename($dir.$file.".temp", $dir.$file);

  if ($meta) {
    open($fh, '>:raw', $dir.$file.".meta.temp");
    print $fh ($meta);
    close($fh);
    rename($dir.$file.".meta.temp", $dir.$file.".meta");
  }
}

sub check_exists{
  my $self = shift;
  my $key = shift;
  
  my $path = $self->get_filepath($key);
  unless (-e $path){
    return 0;
  }
  return 1;
}

sub retrieve_file {
  my $self = shift;
  my $key = shift;

  unless($self->check_exists($key)){
    return undef;
  }
  my $path = $self->get_filepath($key);
  open(my $fh, '<:raw', $path);
  return $fh;
}

sub retrieve_filemeta {
  my $self = shift;
  my $key = shift;

  unless($self->check_exists($key)){
    return undef;
  }
  my $metafile = $self->get_filepath($key) . ".meta";

  # check if metadata is present
  unless (-e $metafile) {
    return undef;
  }

  # limt size of metadata to 8kB
  my $size = -s $metafile;
  unless ($size <= 8192) {
    return undef;
  }

  my $meta;
  open(my $fh, '<:raw', $metafile);
  read ($fh, $meta, $size);
  return $meta;
}

sub get_size{
  my $self = shift;
  my $key = shift;

  my $path = $self->get_filepath($key);
  
  unless (-e $path) {
   return 0;
  }
  my $size = -s $path;
  return $size;
}

sub link_files{
  my $self = shift;
  my $source_key = shift;
  my $destination_key = shift;

  my $source_path = $self->get_filepath($source_key);
  my $destination_dir = $self->get_path($destination_key);
  my $destination_path = $self->get_filepath($destination_key);

  make_path($destination_dir);

  link($source_path.".meta", $destination_path.".meta");

  return link($source_path, $destination_path);
}

sub delete_file{
  my $self = shift;
  my $key = shift;

  my $dir = $self->get_path($key);
  my $file = $self->get_filename($key);

  # Remove metadata
  unlink($dir.$file.".meta");

  unless (unlink($dir.$file)) {
    return 1;
  }
  return rmdir($dir);
}

1;
