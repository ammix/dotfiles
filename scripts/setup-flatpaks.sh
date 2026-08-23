#!/usr/bin/env bash
set -euo pipefail

apps=(
	app.drey.EarTag
	io.github.diegopvlk.Cine
	app.zen_browser.zen
	com.belmoussaoui.Decoder
	com.brave.Browser
	com.calibre_ebook.calibre
	com.discordapp.Discord
	com.github.ADBeveridge.Raider
	com.github.Matoking.protontricks
	com.github.finefindus.eyedropper
	com.github.jeromerobert.pdfarranger
	com.github.tchx84.Flatseal
	com.heroicgameslauncher.hgl
	com.tutanota.Tutanota
	com.valvesoftware.Steam
	com.vysp3r.ProtonPlus
	dev.edfloreshz.CosmicTweaks
	info.febvre.Komikku
	io.bassi.Amberol
	io.github.Faugus.faugus-launcher
	io.github.flattool.Warehouse
	io.github.idevecore.Valuta
	io.github.seadve.Kooha
	io.gitlab.librewolf-community
	md.obsidian.Obsidian
	org.gnome.Loupe
	org.gnome.Papers
	org.gnome.gitlab.YaLTeR.Identity
	org.gnome.gitlab.YaLTeR.VideoTrimmer
	org.gtk.Gtk3theme.adw-gtk3
	org.gtk.Gtk3theme.adw-gtk3-dark
	org.jdownloader.JDownloader
	org.kde.drawy
	org.localsend.localsend_app
	org.qbittorrent.qBittorrent
	fr.handbrake.ghb
)

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

system_apps_output=$(flatpak list --system --app --columns=application)
if [[ -n "${system_apps_output//[[:space:]]/}" ]]; then
	mapfile -t system_apps <<<"$system_apps_output"
	for app_id in "${system_apps[@]}"; do
		[[ -n "$app_id" ]] || continue
		flatpak install --user --assumeyes flathub "$app_id"
		flatpak uninstall --system --assumeyes "$app_id"
	done
fi

system_refs_output=$(flatpak list --system --columns=ref)
if [[ -n "${system_refs_output//[[:space:]]/}" ]]; then
	mapfile -t system_refs <<<"$system_refs_output"
	flatpak uninstall --system --assumeyes "${system_refs[@]}"
fi

system_remotes_output=$(flatpak remotes --system --columns=name)
if [[ -n "${system_remotes_output//[[:space:]]/}" ]]; then
	mapfile -t system_remotes <<<"$system_remotes_output"
	for remote in "${system_remotes[@]}"; do
		[[ -n "$remote" ]] || continue
		flatpak remote-delete --system "$remote"
	done
fi

flatpak install --user --noninteractive flathub "${apps[@]}"
