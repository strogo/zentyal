# Copyright (C) 2007 Warp Networks S.L.
# Copyright (C) 2009-2010 eBox Technologies S.L.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

package EBox::Mail::Composite::Report::TrafficReport;

use base 'EBox::Model::Composite';

use strict;
use warnings;

## eBox uses
use EBox::Gettext;

# Group: Public methods

# Constructor: new
#
#         Constructor for the general mail composite
#
# Returns:
#
#       <EBox::Squid::Model::GeneralComposite> - a
#       general mail composite
#
sub new
  {

      my ($class, @params) = @_;

      my $self = $class->SUPER::new(@params);

      return $self;

  }



# Group: Protected methods

# Method: _description
#
# Overrides:
#
#     <EBox::Model::Composite::_description>
#
sub _description
  {

      my $description =
        {
         components      => [
                             '/mail/TrafficReportOptions',
                             '/mail/TrafficGraph',
                             '/mail/TrafficDetails',
                            ],
         layout          => 'top-bottom',
         name            => 'TrafficReport',
         printableName   => __('Mail traffic reports'),
         pageTitle   => __('Mail traffic report'),
         compositeDomain => 'Mail',
#         help            => __(''),
        };

      return $description;

  }

1;
