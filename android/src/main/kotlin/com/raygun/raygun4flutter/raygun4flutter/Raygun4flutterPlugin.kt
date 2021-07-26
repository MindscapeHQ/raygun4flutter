package com.raygun.raygun4flutter.raygun4flutter

import android.app.Application
import android.content.Context
import androidx.annotation.NonNull;
import com.raygun.raygun4android.RaygunClient
import com.raygun.raygun4android.messages.shared.RaygunUserInfo

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** Raygun4flutterPlugin */
class Raygun4flutterPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    // Application Context
    // Null when Flutter Engine is not attached
    private var context: Context? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(
            flutterPluginBinding.getFlutterEngine().getDartExecutor(),
            "com.raygun.raygun4flutter/raygun4flutter"
        )
        channel.setMethodCallHandler(this);
    }

    override fun onMethodCall(@NonNull methodCall: MethodCall, @NonNull result: Result) {
        when (methodCall.method) {
            "init" -> onInit(methodCall)
            "send" -> onSend(methodCall)
            "recordBreadcrumb" -> onBreadcrumb(methodCall)
            "setUserId" -> onUserId(methodCall)
            "setUser" -> onUser(methodCall)
            "setTags" -> onSetTags(methodCall)
            "setCustomData" -> onSetCustomData(methodCall)
            "setVersion" -> onVersion(methodCall)
            else -> result.notImplemented()
        }
        result.success(null)
    }

    private fun onVersion(methodCall: MethodCall) {
        val version = methodCall.argument<String?>("version")
        RaygunClient.setVersion(version)
    }

    private fun onUser(methodCall: MethodCall) {
        val identifier = methodCall.argument<String?>("identifier")
        val email = methodCall.argument<String?>("email")
        val firstName = methodCall.argument<String?>("firstName")
        val fullName = methodCall.argument<String?>("fullName")
        val info = RaygunUserInfo(identifier, firstName, fullName, email);
        RaygunClient.setUser(info)
    }

    private fun onSetCustomData(methodCall: MethodCall) {
        val customData = methodCall.arguments as Map<*, *>?
        RaygunClient.setCustomData(customData)
    }

    private fun onSetTags(methodCall: MethodCall) {
        val tags = methodCall.arguments as List<*>?
        RaygunClient.setTags(tags)
    }

    private fun onInit(methodCall: MethodCall) {
        val apiKey = methodCall.argument<String>("apiKey")
        val version = methodCall.argument<String?>("version")
        RaygunClient.init(context as Application, apiKey, version)
        RaygunClient.enableCrashReporting()
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }

    private fun onSend(methodCall: MethodCall) {
        val className = methodCall.argument<String>("className")
        val reason = methodCall.argument<String>("reason")
        val flutterStackTrace = methodCall.argument<String>("stackTrace")
        val tags = methodCall.argument<List<*>>("tags")
        val customData = methodCall.argument<Map<*, *>>("customData")
        RaygunClient.send(
            FlutterException(
                message = reason,
                flutterStackTrace = flutterStackTrace,
                className = className
            ),
            tags,
            customData
        )
    }

    private fun onBreadcrumb(methodCall: MethodCall) {
        val message = methodCall.argument<String>("message") ?: ""
        RaygunClient.recordBreadcrumb(message)
    }

    private fun onUserId(methodCall: MethodCall) {
        val userId = methodCall.argument<String>("userId")
        val userInfo = userId?.let {
            RaygunUserInfo(it, "", "", "");
        } ?: RaygunUserInfo()
        RaygunClient.setUser(userInfo)
    }
}

class FlutterException(
    val className: String?,
    override val message: String?,
    flutterStackTrace: String?
) : Throwable(message = message) {

    init {
        if (flutterStackTrace != null) {
            val stackList = flutterStackTrace.split(";")
            stackTrace = stackList.map {
                val parts = it.split("#")
                if (parts.size == 2) {
                    StackTraceElement(
                        parts[0],
                        "",
                        parts[1], // Already contains fileName and line:column
                        0
                    )
                } else {
                    StackTraceElement(
                        "",
                        "",
                        it, // Already contains fileName and line:column
                        0
                    )
                }
            }.toTypedArray()
        }
    }
}
