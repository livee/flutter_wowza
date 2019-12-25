/**
 *
 *  This is sample code provided by Wowza Media Systems, LLC.  All sample code is intended to be a reference for the
 *  purpose of educating developers, and is not intended to be used in any production environment.
 *
 *  IN NO EVENT SHALL WOWZA MEDIA SYSTEMS, LLC BE LIABLE TO YOU OR ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL,
 *  OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION,
 *  EVEN IF WOWZA MEDIA SYSTEMS, LLC HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *  WOWZA MEDIA SYSTEMS, LLC SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. ALL CODE PROVIDED HEREUNDER IS PROVIDED "AS IS".
 *  WOWZA MEDIA SYSTEMS, LLC HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 *  © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
 */

package com.livee.app;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.preference.PreferenceManager;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.SeekBar;
import android.widget.TextView;

import com.wowza.gocoder.sdk.api.WowzaGoCoder;
import com.wowza.gocoder.sdk.api.configuration.WOWZMediaConfig;
import com.wowza.gocoder.sdk.api.data.WOWZDataEvent;
import com.wowza.gocoder.sdk.api.data.WOWZDataMap;
import com.wowza.gocoder.sdk.api.errors.WOWZStreamingError;
import com.wowza.gocoder.sdk.api.logging.WOWZLog;
import com.wowza.gocoder.sdk.api.player.WOWZPlayerConfig;
import com.wowza.gocoder.sdk.api.player.WOWZPlayerView;
import com.wowza.gocoder.sdk.api.status.WOWZPlayerStatus;
import com.wowza.gocoder.sdk.api.status.WOWZPlayerStatus.PlayerState;
import com.wowza.gocoder.sdk.api.status.WOWZPlayerStatusCallback;
import com.livee.app.config.GoCoderSDKPrefs;
import com.livee.app.ui.DataTableFragment;
import com.livee.app.ui.MultiStateButton;
import com.livee.app.ui.StatusView;
import com.livee.app.ui.TimerView;
import com.livee.app.ui.VolumeChangeObserver;

public class PlayerActivity extends GoCoderSDKActivityBase implements WOWZPlayerStatusCallback {
    final private static String TAG = PlayerActivity.class.getSimpleName();

    // Stream player view
    private WOWZPlayerView mStreamPlayerView = null;
    private WOWZPlayerConfig mStreamPlayerConfig = null;

    // UI controls
    private MultiStateButton    mBtnPlayStream   = null;
    private MultiStateButton    mBtnSettings     = null;
    private MultiStateButton    mBtnMic          = null;
    private MultiStateButton    mBtnScale        = null;
    private SeekBar             mSeekVolume      = null;
    private ProgressDialog      mBufferingDialog = null;
    private ProgressDialog mGoingDownDialog =null;
    private StatusView        mStatusView       = null;
    private TextView          mHelp             = null;
    private TimerView         mTimerView        = null;
    private ImageButton       mStreamMetadata   = null;
    private VolumeChangeObserver mVolumeSettingChangeObserver = null;
    private final Handler callbackHandler = new Handler(Looper.getMainLooper());

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_stream_player);

        mRequiredPermissions = new String[]{};

        mStreamPlayerView = findViewById(R.id.vwStreamPlayer);

        mBtnPlayStream = findViewById(R.id.ic_play_stream);
        mBtnSettings = findViewById(R.id.ic_settings);
        mBtnMic = findViewById(R.id.ic_mic);
        mBtnScale = findViewById(R.id.ic_scale);

        mTimerView = findViewById(R.id.txtTimer);
        mStatusView = findViewById(R.id.statusView);
        mStreamMetadata = findViewById(R.id.imgBtnStreamInfo);
        mHelp = findViewById(R.id.streamPlayerHelp);

        mSeekVolume = findViewById(R.id.sb_volume);

        mTimerView.setVisibility(View.GONE);


        if (sGoCoderSDK != null) {

            /*
            Packet change listener setup
             */
            WOWZPlayerView.PacketThresholdChangeListener packetChangeListener = new WOWZPlayerView.PacketThresholdChangeListener() {
                @Override
                public void packetsBelowMinimumThreshold(int packetCount) {
                    WOWZLog.debug("Packets have fallen below threshold "+packetCount+"... ");

//                    activity.runOnUiThread(new Runnable() {
//                        public void run() {
//                            Toast.makeText(activity, "Packets have fallen below threshold ... ", Toast.LENGTH_SHORT).show();
//                        }
//                    });
                }

                @Override
                public void packetsAboveMinimumThreshold(int packetCount) {
                    WOWZLog.debug("Packets have risen above threshold "+packetCount+" ... ");

//                    activity.runOnUiThread(new Runnable() {
//                        public void run() {
//                            Toast.makeText(activity, "Packets have risen above threshold ... ", Toast.LENGTH_SHORT).show();
//                        }
//                    });
                }
            };
            mStreamPlayerView.setShowAllNotificationsWhenBelowThreshold(false);
            mStreamPlayerView.setMinimumPacketThreshold(20);
            mStreamPlayerView.registerPacketThresholdListener(packetChangeListener);
            ///// End packet change notification listener

            mTimerView.setTimerProvider(new TimerView.TimerProvider() {
                @Override
                public long getTimecode() {
                    return mStreamPlayerView.getCurrentTime();
                }

                @Override
                public long getDuration() {
                    return mStreamPlayerView.getDuration();
                }
            });

            mSeekVolume.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
                public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                    if (mStreamPlayerView != null && mStreamPlayerView.getCurrentStatus().isPlaying()) {
                        mStreamPlayerView.setVolume(progress);
                    }
                }

                public void onStartTrackingTouch(SeekBar seekBar) {
                }

                public void onStopTrackingTouch(SeekBar seekBar) {
                }
            });

            // listen for volume changes from device buttons, etc.
            mVolumeSettingChangeObserver = new VolumeChangeObserver(this, new Handler());
            getApplicationContext().getContentResolver().registerContentObserver(android.provider.Settings.System.CONTENT_URI, true, mVolumeSettingChangeObserver);
            mVolumeSettingChangeObserver.setVolumeChangeListener(new VolumeChangeObserver.VolumeChangeListener() {
                @Override
                public void onVolumeChanged(int previousLevel, int currentLevel) {
                    if (mSeekVolume != null)
                        mSeekVolume.setProgress(currentLevel);

                    if (mStreamPlayerView != null && mStreamPlayerView.getCurrentStatus().isPlaying()) {
                        mStreamPlayerView.setVolume(currentLevel);
                    }
                }
            });

            mBtnScale.setState(mStreamPlayerView.getScaleMode() == WOWZMediaConfig.FILL_VIEW);

            // The streaming player configuration properties
            mStreamPlayerConfig = new WOWZPlayerConfig();

            mBufferingDialog = new ProgressDialog(this);
            mBufferingDialog.setTitle(R.string.status_buffering);
            mBufferingDialog.setMessage(getResources().getString(R.string.msg_please_wait));
            mBufferingDialog.setButton(DialogInterface.BUTTON_NEGATIVE, getResources().getString(R.string.button_cancel), new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialogInterface, int i) {
                    /// test

                    cancelBuffering();
                }
            });

            mGoingDownDialog = new ProgressDialog(this);
            mGoingDownDialog.setTitle(R.string.status_buffering);
            mGoingDownDialog.setMessage("Please wait while the decoder is shutting down.");

            mStreamPlayerView.registerDataEventListener("onClientConnected", new WOWZDataEvent.EventListener() {
                @Override
                public WOWZDataMap onWZDataEvent(String eventName, WOWZDataMap eventParams) {
                    WOWZLog.info(TAG, "onClientConnected data event received:\n" + eventParams.toString(true));

                    new Handler(Looper.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {

                        }
                    });

                    // this demonstrates how to return a function result back to the original Wowza Streaming Engine
                    // function call request
                    WOWZDataMap functionResult = new WOWZDataMap();
                    functionResult.put("greeting", "Hello New Client!");

                    return functionResult;
                }
            });
            // testing player data event handler.
            mStreamPlayerView.registerDataEventListener("onWowzaData", new WOWZDataEvent.EventListener(){
                @Override
                public WOWZDataMap onWZDataEvent(String eventName, WOWZDataMap eventParams) {
                    String meta = "";
                    if(eventParams!=null)
                        meta = eventParams.toString();


                    WOWZLog.debug("onWZDataEvent -> eventName "+eventName+" = "+meta);

                    return null;
                }
            });

            // testing player data event handler.
            mStreamPlayerView.registerDataEventListener("onStatus", new WOWZDataEvent.EventListener(){
                @Override
                public WOWZDataMap onWZDataEvent(String eventName, WOWZDataMap eventParams) {
                    if(eventParams!=null)
                        WOWZLog.debug("onWZDataEvent -> eventName "+eventName+" = "+eventParams.toString());

                    return null;
                }
            });

            // testing player data event handler.
            mStreamPlayerView.registerDataEventListener("onTextData", new WOWZDataEvent.EventListener(){
                @Override
                public WOWZDataMap onWZDataEvent(String eventName, WOWZDataMap eventParams) {
                    if(eventParams!=null)
                        WOWZLog.debug("onWZDataEvent -> "+eventName+" = "+eventParams.get("text"));

                    return null;
                }
            });
        } else {
            mHelp.setVisibility(View.GONE);
            mStatusView.setErrorMessage(WowzaGoCoder.getLastError().getErrorDescription());
        }

    }

    @Override
    protected void onDestroy() {
        if (mVolumeSettingChangeObserver != null)
            getApplicationContext().getContentResolver().unregisterContentObserver(mVolumeSettingChangeObserver);

        super.onDestroy();
    }

    /**
     * Android Activity class methods
     */
    @Override
    protected void onResume() {
        super.onResume();
        if(
                mStreamPlayerView.getCurrentStatus().getState() != PlayerState.IDLE &&
                        mStreamPlayerView.getCurrentStatus().getState() != PlayerState.PLAYING
        )
        {
            showTearingdownDialog();
            mStreamPlayerView.stop();

            // Wait for the streaming player to disconnect and shutdown...
            mStreamPlayerView.getCurrentStatus().waitForState(PlayerState.IDLE);
            hideTearingdownDialog();
        }
        syncUIControlState();
    }

    @Override
    protected void onPause() {


        if (mStreamPlayerView != null) {

            AsyncTask.execute(new Runnable() {
                @Override
                public void run() {
//                        mStreamPlayerView.stop();

                    // Wait for the streaming player to disconnect and shutdown...
//                    mStreamPlayerView.getCurrentStatus().waitForState(WOWZState.PLAYER_IDLE);
                }
            });
        }

        super.onPause();
    }
    private boolean isNetworkAvailable() {
        ConnectivityManager connectivityManager
                = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivityManager==null)
            return false;
        NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
        return activeNetworkInfo != null && activeNetworkInfo.isConnected();
    }

    /*
    Click handler for network pausing
     */
    public void onPauseNetwork(View v)
    {
        Button btn = findViewById(R.id.pause_network);
        if(btn.getText().toString().trim().equalsIgnoreCase("pause network")) {
            WOWZLog.info("Pausing network...");
            btn.setText(R.string.wz_unpause_network);
            mStreamPlayerView.pauseNetworkStack();
        }
        else{
            WOWZLog.info("Unpausing network... btn.getText(): "+btn.getText());
            btn.setText(R.string.wz_pause_network);
            mStreamPlayerView.unpauseNetworkStack();
        }
    }

    public void playStream()
    {
        if(!this.isNetworkAvailable()){
            displayErrorDialog("No internet connection, please try again later.");
            return;
        }
        showBuffering();
        mStreamPlayerView.setMaxSecondsWithNoPackets(4);
        mHelp.setVisibility(View.GONE);
        WOWZStreamingError configValidationError = mStreamPlayerConfig.validateForPlayback();
        if (configValidationError != null) {
            mStatusView.setErrorMessage(configValidationError.getErrorDescription());
        } else {
            // Set the detail level for network logging output
            mStreamPlayerView.setLogLevel(mWZNetworkLogLevel);

            // Set the player's pre-buffer duration as stored in the app prefs
            float preBufferDuration = GoCoderSDKPrefs.getPreBufferDuration(PreferenceManager.getDefaultSharedPreferences(this));

            mStreamPlayerConfig.setPreRollBufferDuration(preBufferDuration);
            // Start playback of the live stream
            mStreamPlayerView.play(mStreamPlayerConfig, this);
        }
    }

    /**
     * Click handler for the playback button
     */
    public void onTogglePlayStream(View v) {
        if (mStreamPlayerView.getCurrentStatus().isPlaying()) {
            mStreamPlayerView.stop();
        } else if (mStreamPlayerView.isReadyToPlay()) {
            this.playStream();
        }
    }


    @Override
    public synchronized void onWZStatus(WOWZPlayerStatus status) {
        final WOWZPlayerStatus playerStatus = status;
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                switch (playerStatus.getState()) {
                    case BUFFERING:
                        showBuffering();
                        break;
                    case CONNECTING:
                        showStartingDialog();
                        break;
                    case STOPPING:
                        hideBuffering();
                        showTearingdownDialog();
                        break;
                    case PLAYING:
                        hideBuffering();

                        // Keep the screen on while we are playing back the stream
                        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

                        mTimerView.startTimer();

                        // Since we have successfully opened up the server connection, store the connection info for auto complete
                        GoCoderSDKPrefs.storeHostConfig(PreferenceManager.getDefaultSharedPreferences(PlayerActivity.this), mStreamPlayerConfig);
                        break;

                    case IDLE:
                        if (playerStatus.getLastError() != null) {
                            displayErrorDialog(playerStatus.getLastError());
                        }
                        playerStatus.clearLastError();
                        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

                        mTimerView.stopTimer();
                        hideTearingdownDialog();
                        break;
                }
                syncUIControlState();
            }
        });
    }

    @Override
    public synchronized void onWZError(final WOWZPlayerStatus playerStatus) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                displayErrorDialog(playerStatus.getLastError());
                syncUIControlState();
            }
        });
    }

    /**
     * Click handler for the mic/mute button
     */
    public void onToggleMute(View v) {
        mBtnMic.toggleState();

        if (mStreamPlayerView != null)
            mStreamPlayerView.mute(!mBtnMic.isOn());

        mSeekVolume.setEnabled(mBtnMic.isOn());
    }

    public void onToggleScaleMode(View v) {
        int newScaleMode = mStreamPlayerView.getScaleMode() == WOWZMediaConfig.RESIZE_TO_ASPECT ? WOWZMediaConfig.FILL_VIEW : WOWZMediaConfig.RESIZE_TO_ASPECT;
        mBtnScale.setState(newScaleMode == WOWZMediaConfig.FILL_VIEW);
        mStreamPlayerView.setScaleMode(newScaleMode);
    }

    /**
     * Click handler for the metadata button
     */
    public void onStreamMetadata(View v) {
        WOWZDataMap streamMetadata = mStreamPlayerView.getMetadata();
        WOWZDataMap streamStats = mStreamPlayerView.getStreamStats();
        WOWZDataMap streamInfo = new WOWZDataMap();

        streamInfo.put("- Stream Statistics -", streamStats);
        streamInfo.put("- Stream Metadata -", streamMetadata);
        //streamInfo.put("- Stream Configuration -", streamConfig);

        DataTableFragment dataTableFragment = DataTableFragment.newInstance("Stream Information", streamInfo, false);

        // Display/hide the data table fragment
        getFragmentManager().beginTransaction()
                .add(android.R.id.content, dataTableFragment)
                .addToBackStack("metadata_fragment")
                .commit();
    }

    /**
     * Click handler for the settings button
     */
    public void onSettings(View v) {
        // Display the prefs fragment
        GoCoderSDKPrefs.PrefsFragment prefsFragment = new GoCoderSDKPrefs.PrefsFragment();
        prefsFragment.setFixedSource(true);
        prefsFragment.setForPlayback(true);

        getFragmentManager().beginTransaction()
                .replace(android.R.id.content, prefsFragment)
                .addToBackStack(null)
                .commit();
    }

    /**
     * Update the state of the UI controls
     */
    private void syncUIControlState() {
        boolean disableControls =  !(mStreamPlayerView.isReadyToPlay() || mStreamPlayerView.getCurrentStatus().isPlaying()); // (!(GlobalPlayerStateManager.isReady() ||  mStreamPlayerView.isReadyToPlay() || mStreamPlayerView.isPlaying()) || sGoCoderSDK == null);
        if (disableControls) {
            mBtnPlayStream.setEnabled(false);
            mBtnSettings.setEnabled(false);
            mSeekVolume.setEnabled(false);
            mBtnScale.setEnabled(false);
            mBtnMic.setEnabled(false);
            mStreamMetadata.setEnabled(false);
        } else {
            mBtnPlayStream.setState(mStreamPlayerView.getCurrentStatus().isPlaying());
            mBtnPlayStream.setEnabled(true);
            if (mStreamPlayerConfig.isAudioEnabled()) {
                mBtnMic.setVisibility(View.VISIBLE);
                mBtnMic.setEnabled(true);

                mSeekVolume.setVisibility(View.VISIBLE);
                mSeekVolume.setEnabled(mBtnMic.isOn());
                mSeekVolume.setProgress(mStreamPlayerView.getVolume());
            } else {
                mSeekVolume.setVisibility(View.GONE);
                mBtnMic.setVisibility(View.GONE);
            }

            mBtnScale.setVisibility(View.VISIBLE);
            mBtnScale.setVisibility(mStreamPlayerView.getCurrentStatus().isPlaying() && mStreamPlayerConfig.isVideoEnabled() ? View.VISIBLE : View.GONE);
            mBtnScale.setEnabled(mStreamPlayerView.getCurrentStatus().isPlaying() && mStreamPlayerConfig.isVideoEnabled());

            mBtnSettings.setEnabled(!mStreamPlayerView.getCurrentStatus().isPlaying());
            mBtnSettings.setVisibility(mStreamPlayerView.getCurrentStatus().isPlaying() ? View.GONE : View.VISIBLE);

            mStreamMetadata.setEnabled(mStreamPlayerView.getCurrentStatus().isPlaying());
            mStreamMetadata.setVisibility(mStreamPlayerView.getCurrentStatus().isPlaying() ? View.VISIBLE : View.GONE);
        }
    }

    private void showStartingDialog(){
//
//
        try {
            if (mBufferingDialog == null) return;
//            hideBuffering();
            mBufferingDialog.setMessage(getResources().getString(R.string.msg_connecting));
            if(!mBufferingDialog.isShowing()) {
                mBufferingDialog.setCancelable(false);
                mBufferingDialog.show();
            }
        }
        catch(Exception ex){
            WOWZLog.warn(TAG, "showTearingdownDialog:" + ex);
        }
    }

    private void showTearingdownDialog(){
        try {
            if (mGoingDownDialog == null) return;
            hideBuffering();
            if(!mGoingDownDialog.isShowing()) {
                mGoingDownDialog.setCancelable(false);
                mGoingDownDialog.show();
            }
        }
        catch(Exception ex){
            WOWZLog.warn(TAG, "showTearingdownDialog:" + ex);
        }
    }
    private void hideTearingdownDialog(){

        try {
            if (mGoingDownDialog == null) return;
            hideBuffering();
            mGoingDownDialog.dismiss();
        }
        catch(Exception ex){
            WOWZLog.warn(TAG, "hideTearingdownDialog exception:" + ex);
        }
    }
    private void showBuffering() {
        try {
            if (mBufferingDialog == null) return;

            if(mBufferingDialog.isShowing()){
                mBufferingDialog.setMessage(getResources().getString(R.string.msg_please_wait));
                return;
            }

            final Handler mainThreadHandler = new Handler(getBaseContext().getMainLooper());
            mBufferingDialog.setCancelable(false);
            mBufferingDialog.show();
            mBufferingDialog.getButton(DialogInterface.BUTTON_NEGATIVE).setEnabled(false);
            (new Thread(){
                public void run(){

                    mainThreadHandler.post(new Runnable() {
                        @Override
                        public void run() {
                            mBufferingDialog.getButton(DialogInterface.BUTTON_NEGATIVE).setEnabled(true);
                        }
                    });
                }
            }).start();
        }
        catch(Exception ex) {
            WOWZLog.warn(TAG, "showBuffering:" + ex);
        }
    }

    private void cancelBuffering() {

        showTearingdownDialog();
        mStreamPlayerView.stop();
        hideTearingdownDialog();

    }

    private void hideBuffering() {
        if (mBufferingDialog!=null && mBufferingDialog.isShowing())
            mBufferingDialog.dismiss();
    }

    @Override
    public void syncPreferences() {
        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
        String sLogLevel = prefs.getString("wz_debug_net_log_level", String.valueOf(WOWZLog.LOG_LEVEL_DEBUG));
        if (sLogLevel!=null)
            mWZNetworkLogLevel = Integer.valueOf(sLogLevel);

        mStreamPlayerConfig.setIsPlayback(true);
        if (mStreamPlayerConfig != null)
            GoCoderSDKPrefs.updateConfigFromPrefsForPlayer(prefs, mStreamPlayerConfig);
    }

}
