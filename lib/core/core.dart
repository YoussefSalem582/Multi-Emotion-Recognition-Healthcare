// Flutter packages
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:provider/provider.dart';
export 'dart:math';
export 'package:flutter_animate/flutter_animate.dart';

// Third-party packages
// Add more exports as needed

// Theme
export 'theme/app_theme.dart';

// Utils - Centralized export from utils.dart
export 'utils/utils.dart';

// Routes
export 'helper_functions/on_generate_routes.dart';

// Data sources
export '../data/datasources/mock_emotion_datasource.dart';
export '../data/datasources/mock_session_datasource.dart';

// Repositories
export '../data/repositories/emotion_repository_impl.dart';
export '../data/repositories/session_repository_impl.dart';

// Use cases
export '../domain/usecases/detect_emotions_usecase.dart';
export '../domain/usecases/get_sessions_usecase.dart';

// Providers
export '../presentation/providers/emotion_provider.dart';
export '../presentation/providers/session_provider.dart';
export '../presentation/providers/theme_provider.dart';

// Controllers
export '../presentation/controllers/navigation_controller.dart';

// Export all widgets
export 'widgets/widgets.dart';
