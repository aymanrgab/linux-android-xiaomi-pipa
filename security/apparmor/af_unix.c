// SPDX-License-Identifier: GPL-2.0
/*
 * AppArmor security module
 *
 * This file contains AppArmor af_unix fine grained mediation
 *
 * Copyright 2014 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, version 2 of the
 * License.
 */

#include <net/tcp_states.h>

#include "include/af_unix.h"
#include "include/apparmor.h"
#include "include/audit.h"
#include "include/cred.h"
#include "include/file.h"
#include "include/label.h"
#include "include/net.h"
#include "include/path.h"
#include "include/policy.h"

static int aa_profile_unix_perm(struct aa_profile *profile,
				struct common_audit_data *sa,
				u32 request, struct sock *sk)
{
	if (!PROFILE_MEDIATES_AF(profile, AF_UNIX))
		return 0;
	return aa_profile_af_sk_perm(profile, sa, request, sk);
}

static int aa_profile_unix_peer_perm(struct aa_profile *profile,
				     struct common_audit_data *sa,
				     u32 request, struct sock *sk,
				     struct sock *peer_sk)
{
	if (!PROFILE_MEDIATES_AF(profile, AF_UNIX))
		return 0;
	return aa_profile_af_sk_perm(profile, sa, request, sk);
}

static int aa_profile_unix_file_perm(struct aa_profile *profile,
				     struct common_audit_data *sa,
				     u32 request, struct socket *sock)
{
	if (!PROFILE_MEDIATES_AF(profile, AF_UNIX))
		return 0;
	return aa_profile_af_sk_perm(profile, sa, request, sock->sk);
}

/**
 * aa_unix_peer_perm - peer mediation between two unix sockets
 * @label: label being checked
 * @op: name of operation
 * @request: permissions requested
 * @sk: the current sock
 * @peer_sk: the peer sock
 * @peer_label: peer label if known
 */
int aa_unix_peer_perm(struct aa_label *label, const char *op, u32 request,
		      struct sock *sk, struct sock *peer_sk,
		      struct aa_label *peer_label)
{
	struct aa_profile *profile;
	DEFINE_AUDIT_SK(sa, op, sk);

	return fn_for_each_confined(label, profile,
			aa_profile_unix_peer_perm(profile, &sa, request, sk,
						  peer_sk));
}

/**
 * aa_unix_label_sk_perm - label based socket perm
 * @label: label being checked
 * @op: name of operation
 * @request: permissions requested
 * @sk: the sock to check permissions on
 */
int aa_unix_label_sk_perm(struct aa_label *label, const char *op, u32 request,
			  struct sock *sk)
{
	struct aa_profile *profile;
	DEFINE_AUDIT_SK(sa, op, sk);

	return fn_for_each_confined(label, profile,
			aa_profile_unix_perm(profile, &sa, request, sk));
}

/**
 * aa_unix_sock_perm - socket operation perm
 * @op: name of operation
 * @request: permissions requested
 * @sock: the socket to check
 */
int aa_unix_sock_perm(const char *op, u32 request, struct socket *sock)
{
	struct aa_label *label;
	int error;

	AA_BUG(!sock);
	AA_BUG(!sock->sk);
	AA_BUG(in_interrupt());

	label = begin_current_label_crit_section();
	error = aa_unix_label_sk_perm(label, op, request, sock->sk);
	end_current_label_crit_section(label);

	return error;
}

/**
 * aa_unix_create_perm - socket creation perm
 * @label: label being checked
 * @family: socket family
 * @type: socket type
 * @protocol: socket protocol
 */
int aa_unix_create_perm(struct aa_label *label, int family, int type,
			int protocol)
{
	return aa_af_perm(label, OP_CREATE, AA_MAY_CREATE, family, type,
			  protocol);
}

/**
 * aa_unix_bind_perm - bind mediation of af_unix sockets
 * @sock: the socket to bind
 * @address: address to bind to
 * @addrlen: length of address
 */
int aa_unix_bind_perm(struct socket *sock, struct sockaddr *address,
		      int addrlen)
{
	struct aa_label *label;
	int error;

	AA_BUG(!sock);
	AA_BUG(!sock->sk);
	AA_BUG(!address);
	AA_BUG(in_interrupt());

	label = begin_current_label_crit_section();
	error = aa_unix_label_sk_perm(label, OP_BIND, AA_MAY_BIND, sock->sk);
	end_current_label_crit_section(label);

	return error;
}

/**
 * aa_unix_connect_perm - connect mediation of af_unix sockets
 * @sock: connecting socket
 * @address: address to connect to
 * @addrlen: length of address
 */
int aa_unix_connect_perm(struct socket *sock, struct sockaddr *address,
			 int addrlen)
{
	struct aa_label *label;
	int error;

	AA_BUG(!sock);
	AA_BUG(!sock->sk);
	AA_BUG(!address);
	AA_BUG(in_interrupt());

	label = begin_current_label_crit_section();
	error = aa_unix_label_sk_perm(label, OP_CONNECT, AA_MAY_CONNECT,
				      sock->sk);
	end_current_label_crit_section(label);

	return error;
}

/**
 * aa_unix_listen_perm - listen mediation of af_unix sockets
 * @sock: socket to listen on
 * @backlog: listen backlog
 */
int aa_unix_listen_perm(struct socket *sock, int backlog)
{
	struct aa_label *label;
	int error;

	AA_BUG(!sock);
	AA_BUG(!sock->sk);
	AA_BUG(in_interrupt());

	label = begin_current_label_crit_section();
	error = aa_unix_label_sk_perm(label, OP_LISTEN, AA_MAY_LISTEN,
				      sock->sk);
	end_current_label_crit_section(label);

	return error;
}

/**
 * aa_unix_accept_perm - accept mediation of af_unix sockets
 * @sock: listening socket
 * @newsock: new socket to accept
 */
int aa_unix_accept_perm(struct socket *sock, struct socket *newsock)
{
	struct aa_label *label;
	int error;

	AA_BUG(!sock);
	AA_BUG(!sock->sk);
	AA_BUG(!newsock);
	AA_BUG(in_interrupt());

	label = begin_current_label_crit_section();
	error = aa_unix_label_sk_perm(label, OP_ACCEPT, AA_MAY_ACCEPT,
				      sock->sk);
	end_current_label_crit_section(label);

	return error;
}

/**
 * aa_unix_msg_perm - send/recv msg mediation of af_unix sockets
 * @op: name of operation
 * @request: permissions requested
 * @sock: socket to send/recv on
 * @msg: message header
 * @size: message size
 */
int aa_unix_msg_perm(const char *op, u32 request, struct socket *sock,
		     struct msghdr *msg, int size)
{
	struct aa_label *label;
	int error;

	AA_BUG(!sock);
	AA_BUG(!sock->sk);
	AA_BUG(!msg);
	AA_BUG(in_interrupt());

	label = begin_current_label_crit_section();
	error = aa_unix_label_sk_perm(label, op, request, sock->sk);
	end_current_label_crit_section(label);

	return error;
}

/**
 * aa_unix_opt_perm - socket option mediation
 * @op: name of operation
 * @request: permissions requested
 * @sock: socket to set/get options on
 * @level: protocol level
 * @optname: option name
 */
int aa_unix_opt_perm(const char *op, u32 request, struct socket *sock,
		     int level, int optname)
{
	struct aa_label *label;
	int error;

	AA_BUG(!sock);
	AA_BUG(!sock->sk);
	AA_BUG(in_interrupt());

	label = begin_current_label_crit_section();
	error = aa_unix_label_sk_perm(label, op, request, sock->sk);
	end_current_label_crit_section(label);
	return error;
}

/**
 * aa_unix_file_perm - file based socket permission
 * @label: label being checked
 * @op: name of operation
 * @request: permissions requested
 * @sock: socket to check permissions on
 */
int aa_unix_file_perm(struct aa_label *label, const char *op, u32 request,
		      struct socket *sock)
{
	struct aa_profile *profile;
	DEFINE_AUDIT_SK(sa, op, sock->sk);

	if (!sock || !sock->sk)
		return 0;

	return fn_for_each_confined(label, profile,
			aa_profile_unix_file_perm(profile, &sa, request,
						  sock));
}
