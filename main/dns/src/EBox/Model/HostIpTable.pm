# Copyright (C) 2008-2012 eBox Technologies S.L.
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

# Class:
#
#   EBox::DNS::Model::HostIpTable
#
#   This class inherits from <EBox::Model::DataTable> and represents the
#   object table which basically contains domains names and a reference
#   to a member <EBox::DNS::Model::AliasTable>
#
#
package EBox::DNS::Model::HostIpTable;

use EBox::Global;
use EBox::Gettext;

use EBox::Types::HostIP;
use EBox::Types::Text;

use strict;
use warnings;

use base 'EBox::Model::DataTable';

# Group: Public methods

sub new
{
    my $class = shift;
    my %parms = @_;

    my $self = $class->SUPER::new(@_);
    bless ($self, $class);

    return $self;
}

# Method: validateTypedRow
#
# Overrides:
#
#    <EBox::Model::DataTable::validateTypedRow>
#
# Exceptions:
#
#    <EBox::Exceptions::External> - thrown if there is a hostname with
#    the same ip
#
sub validateTypedRow
{
    my ($self, $action, $changedFields, $allFields) = @_;

    return unless (exists $changedFields->{ip});

    # Check there is no A RR in the same domain with the same ip
    my $ip = $changedFields->{ip};
    my $id = $ip->row()->id();

    my $hostnameRow = $ip->row();
    my $hostnameParentRow = $hostnameRow->parentRow();
    my $hostnameModel = $hostnameParentRow->model();
    my $hostnameIds = $hostnameModel->ids();
    foreach my $hostId (@{$hostnameIds}) {
        next if ($hostId eq $id);

        my $hostname = $ip->row()->parentRow()->model()->row($hostId);
        my $hostIpModel   = $hostname->subModel('ipAddresses');
        foreach my $ipId (@{$hostIpModel->ids()}) {
            my $aIp = $hostIpModel->row($ipId);
            if ($aIp->elementByName('ip')->isEqualTo($ip)) {
                throw EBox::Exceptions::External(
                  __x("The IP '{ip}' is already assigned to host '{name}' " .
                      "in the same domain",
                      name => $hostname->valueByName('hostname'),
                      ip   => $ip->value()));
            }
        }
    }
}

sub pageTitle
{
    my ($self) = @_;
    return $self->parentRow()->printableValueByName('hostname');
}

# Group: Protected methods

# Method: _table
#
# Overrides:
#
#    <EBox::Model::DataTable::_table>
#
sub _table
{
    my @tableHead = (
        new EBox::Types::HostIP(
            fieldName => 'ip',
            printableName => __('IP'),
            size => '20',
            unique => 1,
            editable => 1,
        ),
        new EBox::Types::Text(
            fieldName => 'dhcp_iface',
            printableName => __('DHCP interface'),
            optional => 1,
            editable => 0,
            hidden => 1,
        ),
    );

    my $dataTable = { tableName => 'HostIpTable',
                      printableTableName => __('IP'),
                      automaticRemove => 1,
                      defaultController => '/Dns/Controller/HostIpTable',
                      defaultActions => ['add', 'del', 'editField',  'changeView'],
                      tableDescription => \@tableHead,
                      class => 'dataTable',
                      help => __('The host name will be resolved to this list of IP addresses.'),
                      printableRowName => __('IP') };

    return $dataTable;
}

1;
