package states;

import states.FreeplayState;
import states.editors.MasterEditorMenu;
import states.ModsMenuState;
import options.OptionsState;

class SongSelectState extends MusicBeatState
{
    var songs:Array<String> = new Array();
    var songGrp:FlxSpriteGroup = new FlxSpriteGroup();
    
    var curSelected:Int = 0;
    var curItem(get, never):String;

    function get_curItem():String
        return songs[curSelected];


    function changeSelection(v:Int = 0)
    {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        var newSel = curSelected + v;
        newSel = newSel % songs.length;
        if (newSel < 0) newSel = songs.length - 1;
        curSelected = newSel;
        FlxG.camera.follow(songGrp.members[curSelected]);

        trace(curSelected);
    }

    override public function create()
    {
        super.create();

        songs = CoolUtil.coolTextFile(Paths.txt('songList'));
        songs.push('Extras');
        songs.push('Options');

        var i = 0;

        for (song in songs)
        {
            var songText = new FlxText();
            songText.text = song;
            songText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            songText.screenCenter();
            songText.x += i*25;
            songText.y += i*128;

            songGrp.add(songText);

            i ++;
        }
        
        add(songGrp);
    }


    var frame = 0;

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        frame ++;

        if (controls.UI_DOWN_P)
            changeSelection(1);
        if (controls.UI_UP_P)
            changeSelection(-1);
        if (controls.ACCEPT)
        {
            FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);


			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
                switch (curItem)
                {
                    case 'Extras':
                        MusicBeatState.switchState(new FreeplayState());

                    case 'Options':
                        MusicBeatState.switchState(new OptionsState());
						OptionsState.onPlayState = false;
						if (PlayState.SONG != null)
						{
							PlayState.SONG.arrowSkin = null;
							PlayState.SONG.splashSkin = null;
							PlayState.stageUI = 'normal';
						}

                    default:
                        trace('todo');
                }
			});
        }

        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new TitleState());
        }

        
        if (controls.justPressed('debug_1'))
		{
			MusicBeatState.switchState(new MasterEditorMenu());
		}

        #if MODS_ALLOWED
        if (controls.justPressed('debug_2'))
		{
			MusicBeatState.switchState(new ModsMenuState());
		}
        #end
    }
}