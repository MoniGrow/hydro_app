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
import com.google.firebase.database.*
import com.google.firebase.ktx.Firebase
import io.flutter.plugins.firebase.auth.Constants.TAG


@IgnoreExtraProperties
data class Temperature(val temperature: Double? = null, val timestamp: Double? = null) {
}

/**
 * todo let user select the data type (or just do all of them)
 * todo open the app when touched
 */
class StatDisplayWidget : AppWidgetProvider() {
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

    private fun generateListener(field: String, uid: String, db: FirebaseDatabase, rv: RemoteViews, appWidgetManager: AppWidgetManager, appWidgetId: Int, textId: Int) {
        val ref = db.getReference("users/$uid/sensor_data/$field")
        ref.orderByChild("timestamp").limitToLast(1).addValueEventListener(object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                if (snapshot.exists()) {
                    // unchecked cast because i dont care enough
                    val data: HashMap<String, HashMap<String, Any>> = snapshot.value as HashMap<String, HashMap<String, Any>>
                    Log.d(TAG, "Current data: $data")
                    Log.d(TAG, "type: ${data::class.qualifiedName}")
                    for (x in data) {
                        if (x.component2()[field] is Long || x.component2()[field] is Int) {
                            currentValue = x.component2()[field].toString()
                        } else {
                            currentValue = "%.2f".format(x.component2()[field])
                        }
                    }
                    // todo: only update when new data is in?
                    rv.setTextViewText(textId, "$field: $currentValue")
                    // Instruct the widget manager to update the widget
                    appWidgetManager.updateAppWidget(appWidgetId, rv)
                } else {
                    Log.d(TAG, "No data in snapshot.")
                }
            }

            override fun onCancelled(error: DatabaseError) {
                Log.w(TAG, "Failed to read value.", error.toException())
            }
        })
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        Log.d(TAG, "updating widget")
        val rv = RemoteViews(context.packageName, R.layout.stat_display_widget)
        val db = FirebaseDatabase.getInstance()
        auth = Firebase.auth
        if (auth.currentUser == null) {
            // should probably change so that text on widget shows no user anymore, but
            // it's whatever
            Log.d(TAG, "USER IS NULL, NOT FOUND LLLLLLLLLLLLLLLLLLLLLLLLLLLL")
            rv.setTextViewText(R.id.waterlevel_text, "No user or data")
            rv.setTextViewText(R.id.humidity_text, "")
            rv.setTextViewText(R.id.temp_text, "")
            // Instruct the widget manager to update the widget
            appWidgetManager.updateAppWidget(appWidgetId, rv)
            return
        }
        auth.currentUser?.let { user ->
            Log.d(TAG, "User found")
            val uid = user.uid
            generateListener("temperature", uid, db, rv, appWidgetManager, appWidgetId, R.id.temp_text)
            generateListener("humidity", uid, db, rv, appWidgetManager, appWidgetId, R.id.humidity_text)
            generateListener("water_level", uid, db, rv, appWidgetManager, appWidgetId, R.id.waterlevel_text)
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
