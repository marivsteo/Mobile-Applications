package ro.cojocar.dan.recyclerview.cameras

import java.util.*

object Cameras {

  val CAMERAS: MutableList<Camera> = ArrayList()

  val CAMERA_MAP: MutableMap<String, Camera> = HashMap()

  private const val COUNT = 25

  init {
    // Add some sample items.
    for (i in 1..COUNT) {
      addCamera(createCamera(i, "Camera $i", "Full frame", "35mm full frame", i*10.1))
    }
  }

  private fun addCamera(camera: Camera) {
    CAMERAS.add(camera)
    CAMERA_MAP[camera.id] = camera
  }

  private fun createCamera(position: Int, name: String, type: String, sensor: String, pixels: Double): Camera {
    return Camera(position.toString(), name, type, sensor, pixels)
  }

  public fun makeDetails(camera: Camera): String {
    val builder = StringBuilder()
    builder.append("\nCamera name: ${camera.name} \n")
    builder.append("\nType: ${camera.type} \n")
    builder.append("\nSensor: ${camera.sensor} \n")
    builder.append("\nNumber of mega-pixels: ${camera.pixels}")
    return builder.toString()
  }

  data class Camera(val id: String, val name: String, val type: String, val sensor: String, val pixels: Double) {
    override fun toString(): String = name
  }
}
