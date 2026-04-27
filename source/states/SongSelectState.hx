package states;

import states.FreeplayState;
import states.editors.MasterEditorMenu;
import states.ModsMenuState;
import options.OptionsState;
import backend.Song;
import backend.WeekData;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;

class SongSelectState extends MusicBeatState
{
    var songs:Array<String> = new Array();
    var songGrp:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
    
    var curSelected:Int = 0;
    var selectedSomethin:Bool = false;

    var curItem(get, never):String;
    function get_curItem():String
        return songs[curSelected];

    override public function create()
    {
        super.create();

        if (FlxG.sound.music != null && !FlxG.sound.music.playing)
            FlxG.sound.playMusic(Paths.music('freakyMenu'));

        songs = CoolUtil.coolTextFile(Paths.txt('songList'));
        songs.push('Extras');
        songs.push('Options');

        add(songGrp);

        for (i in 0...songs.length)
        {
            var songText:FlxText = new FlxText(0, (i * 130), 0, songs[i], 64);
            songText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            songText.screenCenter(X);
            songText.ID = i;
            songGrp.add(songText);
        }

        FlxG.camera.follow(songGrp.members[curSelected], null, 0.06);
        changeSelection();
    }

    function changeSelection(v:Int = 0)
    {
        if (selectedSomethin) return;

        FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelected += v;

        if (curSelected < 0) curSelected = songs.length - 1;
        if (curSelected >= songs.length) curSelected = 0;

        for (item in songGrp.members)
        {
            item.alpha = 0.6;
            if (item.ID == curSelected)
            {
                item.alpha = 1;
                FlxG.camera.follow(item, null, 0.06);
            }
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (!selectedSomethin)
        {
            if (controls.UI_UP_P) changeSelection(-1);
            if (controls.UI_DOWN_P) changeSelection(1);

            if (controls.BACK)
            {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new TitleState());
            }

            if (controls.ACCEPT)
            {
                selectedSomethin = true;
                FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
                
                if (ClientPrefs.data.flashing)
                    FlxFlicker.flicker(songGrp.members[curSelected], 1, 0.06, false);

                new FlxTimer().start(1, function(tmr:FlxTimer)
                {
                    switch (curItem)
                    {
                        case 'Extras':
                            MusicBeatState.switchState(new FreeplayState());

                        case 'Options':
                            OptionsState.onPlayState = false;
                            if (PlayState.SONG != null)
                            {
                                PlayState.SONG.arrowSkin = null;
                                PlayState.SONG.splashSkin = null;
                                PlayState.stageUI = 'normal';
                            }
                            MusicBeatState.switchState(new OptionsState());

                        default:
                            var songLowercase:String = Paths.formatToSongPath(curItem);
                            PlayState.SONG = Song.loadFromJson(songLowercase, songLowercase);
                            PlayState.isStoryMode = false;
                            PlayState.storyDifficulty = 1;
                            LoadingState.prepareToSong();
                            LoadingState.loadAndSwitchState(new PlayState());
                    }
                });
            }

            if (controls.justPressed('debug_1'))
                MusicBeatState.switchState(new MasterEditorMenu());

            #if MODS_ALLOWED
            if (controls.justPressed('debug_2'))
                MusicBeatState.switchState(new ModsMenuState());
            #end
        }
    }
}