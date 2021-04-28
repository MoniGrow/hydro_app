package com.monigrow.hydro_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ActivityNotFoundException
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import android.widget.Toast
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.ktx.auth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.FirebaseFirestoreException
import com.google.firebase.firestore.Query
import com.google.firebase.firestore.QuerySnapshot
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import io.flutter.plugins.firebase.auth.Constants.TAG


/**
 * todo let user select the data type (or just do all of them)
 * todo open the app when touched
 */
class StatDisplayWidget : AppWidgetProvider() {
    private lateinit var db: FirebaseFirestore
    private lateinit var auth: FirebaseAuth
    private var currentValue: String = "None"

    /**
     * This thing updates every 30 minutes (the smallest interval possible) with
     * the latest data. This shouldn't drain battery, I think.
     */
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            addAppLaunchIntent(context, appWidgetManager, appWidgetId)
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun addAppLaunchIntent(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        try {
            val intent = Intent("android.intent.action.MAIN")
            intent.addCategory("android.intent.category.LAUNCHER")
            intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION)
            intent.component = ComponentName(context.packageName, MainActivity::class.java.name)
            val pendingIntent: PendingIntent = PendingIntent.getActivity(
                    context, 0, intent, 0)
            val views = RemoteViews(context.packageName, R.layout.stat_display_widget)
            views.setOnClickPendingIntent(R.id.app_button, pendingIntent)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        } catch (e: ActivityNotFoundException) {
            Toast.makeText(context.applicationContext,
                    "There was a problem loading the application: ",
                    Toast.LENGTH_SHORT).show()
        }
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        Log.d(TAG, "updating widget")
        val rv = RemoteViews(context.packageName, R.layout.stat_display_widget)
        db = Firebase.firestore
        auth = Firebase.auth
        if (auth.currentUser == null) {
            // should probably change so that text on widget shows no user anymore, but
            // it's whatever
            Log.d(TAG, "USER IS NULL, NOT FOUND LLLLLLLLLLLLLLLLLLLLLLLLLLLL")
            rv.setTextViewText(R.id.waterlevel_text, "No user or data")
            // Instruct the widget manager to update the widget
            appWidgetManager.updateAppWidget(appWidgetId, rv)
            return
        }
        auth.currentUser?.let { user ->
            Log.d(TAG, "User found")
            val uid = user.uid
            val docRef = db.collection("ESP32data").document(uid).collection("sensorData")
            docRef.orderBy("timestamp", Query.Direction.DESCENDING).limit(1).get().addOnSuccessListener { snapshot ->
                if (snapshot != null && !snapshot.isEmpty) {
                    Log.d(TAG, "Current data: ${snapshot.first().data}")
                    currentValue = snapshot.first().data["temperature"].toString()
                    // todo: only update when new data is in?
                    rv.setTextViewText(R.id.waterlevel_text, "temperature: $currentValue")
                    // Instruct the widget manager to update the widget
                    appWidgetManager.updateAppWidget(appWidgetId, rv)
                } else {
                    Log.d(TAG, "No data in snapshot.")
                }
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        // instead of querying every 30 minutes, should probably rely on onReceive
        // it might update often somehow and drain battery though, so maybe not
        super.onReceive(context, intent)
        Log.d(TAG, "Widget intent received: ${intent.action}")
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        Log.d(TAG, "HEY onEnabled GOT CALLED")
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val rv = RemoteViews(context.packageName, R.layout.stat_display_widget)
            rv.removeAllViews(appWidgetId)
        }
    }
}

// doesn't work, how do you use this
// don't use this
class WidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent?): RemoteViewsFactory {
        return WidgetViewsFactory(this.applicationContext, "temperature")
    }
}

// really doesn't work
class WidgetViewsFactory(private val context: Context, private val dataType: String) : RemoteViewsService.RemoteViewsFactory {
    private lateinit var db: FirebaseFirestore
    private lateinit var auth: FirebaseAuth
    private var currentValue: String = "None"

    override fun onCreate() {
        Log.d(TAG, "viewfactory created")
        val rv = RemoteViews(context.packageName, R.layout.stat_display_widget)
        rv.setTextViewText(R.id.waterlevel_text, "hey fuck you")
        db = Firebase.firestore
        auth = Firebase.auth
        auth.currentUser?.let {
            val uid = it.uid
            val docRef = db.collection("ESP32data").document(uid).collection("sensorData")
            docRef.orderBy("timestamp").limit(1).addSnapshotListener {
                snapshot: QuerySnapshot?, error: FirebaseFirestoreException? ->
                if (error != null) {
                    Log.w(TAG, "Listen failed.", error)
                    return@addSnapshotListener
                }
                if (snapshot != null && !snapshot.isEmpty) {
                    Log.d(TAG, "Current data: ${snapshot.first().data}")
                    currentValue = snapshot.first().data[dataType].toString()
                    val appWidgetManager: AppWidgetManager = AppWidgetManager.getInstance(context)
                    val appWidgetIds: IntArray = appWidgetManager.getAppWidgetIds(ComponentName(context.packageName, StatDisplayWidget::class.java.name))
                    appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetIds, R.id.waterlevel_text)
                } else {
                    Log.d(TAG, "No data in snapshot.")
                }
            }
        }
    }

    override fun getLoadingView(): RemoteViews? {
        return null
    }

    override fun getItemId(p0: Int): Long {
        return p0.toLong()
    }

    override fun onDataSetChanged() {
        Log.d(TAG, "onDataSetChanged called")
    }

    override fun hasStableIds(): Boolean {
        return true
    }

    override fun getViewAt(p0: Int): RemoteViews {
        Log.d(TAG, "attempt to get view at $p0")
        val rv = RemoteViews(context.packageName, R.layout.stat_display_widget)
        rv.setTextViewText(R.id.waterlevel_text, "$dataType: $currentValue")
        return rv
    }

    override fun getCount(): Int {
        return 1
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun onDestroy() {

    }
}
