% Search for 802.16e frame preamble.
% Copyright (C) 2011  Alexander Chemeris
%
% This library is free software; you can redistribute it and/or
% modify it under the terms of the GNU Lesser General Public
% License as published by the Free Software Foundation; either
% version 2.1 of the License, or (at your option) any later version.
%
% This library is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% Lesser General Public License for more details.
%
% You should have received a copy of the GNU Lesser General Public
% License along with this library; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301
% USA

% Refer to "8.4.6.1.1 Preamble" of IEEE 802.16-2009 for details about
% 802.16e frame preambles.
%
% Implemented as in "Research In Initial Downlink Synchronization For TDD
% Operation Of IEEE 802.16E OFDMA", 2006, Guo-Wei Ji, David W. Lin, and
% Kun-Chien Hung
%
% And then improved :)

max_length = params.N_sym * params.Ts_samples ; % Maximum frame time
frame_delay = max_length*0; % Skip few frames for testing
sig_in = rcvdDL(1+frame_delay:1+frame_delay+max_length); % Select samples

% Theta is a index of the first sample of the frame
% max_corr is a value of correlation at the index "theta" (just for debug)
% corr is an array of correlation (just for debug)
[theta max_corr corr] = get_symbol_start(sig_in, params);
% Plot timing
figure; hold on ;
plot(abs(corr)); % Plot abs(lambda) to find its maximum
plot(theta, max_corr, 'ro');
hold off;

% Skip Cyclic Prefix
% Initially Theta points to the Cyclic Prefix start
theta = theta + params.Tg_samples;

% ==== Completely untested part start =====
% Calculate fractional part of the Carrier Frequency Offset
%cfo_fraq = -angle(corr(theta))/2/pi;
% Compensate CFO
%rcvdDL = rcvdDL * exp(-1i*(2*pi*cfo_fraq));
% ==== Completely untested part end =====

theta = theta+frame_delay;

clear max_length sig_in max_corr;
