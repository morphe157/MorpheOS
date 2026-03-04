{
  home.file."Applications/Firefox.app/Contents/Resources/defaults/pref/autoconfig.js".text = ''
    pref("general.config.filename", "mozilla.cfg");
    pref("general.config.obscure_value", 0);
  '';

  home.file."Applications/Firefox.app/Contents/Resources/mozilla.cfg".text = ''
    // Mozilla User Preferences
    lockPref("full-screen-api.macos-native-full-screen", false);
    lockPref("full-screen-api.transition-duration.enter", "0 0");
    lockPref("full-screen-api.transition-duration.leave", "0 0");
  '';
}
