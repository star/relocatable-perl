FROM centos:centos6
MAINTAINER Shoichi Kaji <skaji@cpan.org>

RUN yum install -y gcc make perl tar wget
RUN yum clean all
RUN mkdir /tmp/build /artifact

RUN perl -e 'mkdir $_ for grep !-d, @ARGV' /usr/local/lib64 /usr/local/lib /lib/x86_64-linux-gnu /lib64 /lib /usr/lib/x86_64-linux-gnu /usr/lib64 /usr/lib

ADD relocatable-perl-build /tmp/build/relocatable-perl-build
RUN /usr/bin/perl /tmp/build/relocatable-perl-build --perl_version 5.20.2 --prefix /opt/perl

RUN wget --no-check-certificate -q -O - http://cpanmin.us | /opt/perl/bin/perl - -qn --no-man-pages App::cpanminus App::ChangeShebang
RUN /opt/perl/bin/change-shebang -f /opt/perl/bin/*

RUN cp -r /opt/perl /tmp/perl-`/opt/perl/bin/perl -MConfig -e 'print $Config{archname}'`
RUN cd /tmp && tar czf /artifact/perl-`/opt/perl/bin/perl -MConfig -e 'print $Config{archname}'`.tar.gz perl-`/opt/perl/bin/perl -MConfig -e 'print $Config{archname}'`

RUN rm -rf /tmp/perl-`/opt/perl/bin/perl -MConfig -e 'print $Config{archname}'`
RUN rm -rf /tmp/build

CMD ["sleep", "infinity"]
