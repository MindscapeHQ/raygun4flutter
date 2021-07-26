package com.raygun.raygun4flutter.raygun4flutter

import android.app.Application
import android.content.Context
import androidx.annotation.NonNull;
import com.raygun.raygun4android.RaygunClient
import com.raygun.raygun4android.messages.crashreporting.RaygunBreadcrumbLevel
import com.raygun.raygun4android.messages.crashreporting.RaygunBreadcrumbMessage
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
            "clearBreadcrumbs" -> onClearBreadcrumbs()
            "init" -> onInit(methodCall)
            "recordBreadcrumb" -> onBreadcrumb(methodCall)
            "recordBreadcrumbObject" -> onBreadcrumbObject(methodCall)
            "send" -> onSend(methodCall)
            "setCustomData" -> onSetCustomData(methodCall)
            "setCustomCrashReportingEndpoint" -> setCustomCrashReportingEndpoint(methodCall)
            "setTags" -> onSetTags(methodCall)
            "setUser" -> onUser(methodCall)
            "setUserId" -> onUserId(methodCall)
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

    private fun onBreadcrumbObject(methodCall: MethodCall) {
        val message = methodCall.argument<String>("message") ?: ""
        val builder = RaygunBreadcrumbMessage.Builder(message)
        if (methodCall.hasArgument("category")) {
            builder.category(methodCall.argument("category"))
        }
        if (methodCall.hasArgument("level")) {
            val raygunBreadcrumbLevel =
                RaygunBreadcrumbLevel.values()[methodCall.argument("level")!!]
            builder.level(raygunBreadcrumbLevel)
        }
        if (methodCall.hasArgument("customData")) {
            builder.customData(methodCall.argument("customData"))
        }
        if (methodCall.hasArgument("className")) {
            builder.className(methodCall.argument("className"))
        }
        if (methodCall.hasArgument("methodName")) {
            builder.methodName(methodCall.argument("methodName"))
        }
        if (methodCall.hasArgument("lineNumber")) {
            builder.lineNumber(methodCall.argument("lineNumber"))
        }
        RaygunClient.recordBreadcrumb(builder.build())
    }

    private fun onClearBreadcrumbs() {
        RaygunClient.clearBreadcrumbs();
    }

    private fun setCustomCrashReportingEndpoint(methodCall: MethodCall) {
        val url = methodCall.argument<String>("url")
        RaygunClient.setCustomCrashReportingEndpoint(url)
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
