#!/usr/bin/env python3
"""
Version Manager
Reads and manages versions from versions.yaml
Usage: python scripts/version_manager.py [command] [key]
"""

import sys
import yaml
from pathlib import Path


class VersionManager:
    def __init__(self, versions_file='versions.yaml'):
        self.root_dir = Path(__file__).parent.parent
        self.versions_file = self.root_dir / versions_file
        self.versions = self._load_versions()

    def _load_versions(self):
        """Load versions from YAML file"""
        if not self.versions_file.exists():
            raise FileNotFoundError(f"Versions file not found: {self.versions_file}")
        
        with open(self.versions_file, 'r') as f:
            return yaml.safe_load(f)

    def get(self, key_path):
        """
        Get a version value by key path
        Example: get('sdk.flutter') returns '3.38.4'
        """
        keys = key_path.split('.')
        value = self.versions
        
        for key in keys:
            if isinstance(value, dict) and key in value:
                value = value[key]
            else:
                return None
        
        return value

    def get_dependency_version(self, package_name):
        """Get version of a dependency"""
        deps = self.versions.get('dependencies', {})
        if package_name in deps:
            dep = deps[package_name]
            if isinstance(dep, dict):
                return dep.get('version')
            return dep
        return None

    def get_all_dependencies(self):
        """Get all dependencies with their versions"""
        deps = self.versions.get('dependencies', {})
        result = {}
        for name, info in deps.items():
            if isinstance(info, dict):
                result[name] = info.get('version')
            else:
                result[name] = info
        return result

    def sync_flutter_version(self):
        """Sync Flutter version to .flutter-version file"""
        flutter_version = self.get('sdk.flutter')
        if flutter_version:
            flutter_version_file = self.root_dir / '.flutter-version'
            with open(flutter_version_file, 'w') as f:
                f.write(flutter_version)
            print(f"✓ Synced Flutter version to .flutter-version: {flutter_version}")
            return True
        return False

    def sync_pubspec(self):
        """Sync versions to pubspec.yaml"""
        pubspec_path = self.root_dir / 'pubspec.yaml'
        
        if not pubspec_path.exists():
            print("✗ pubspec.yaml not found")
            return False
        
        with open(pubspec_path, 'r') as f:
            pubspec = yaml.safe_load(f)
        
        # Update project version
        project_version = self.get('project.version')
        build_number = self.get('project.build_number')
        if project_version and build_number:
            pubspec['version'] = f"{project_version}+{build_number}"
        
        # Update environment SDK
        dart_version = self.get('sdk.dart')
        if dart_version:
            pubspec['environment']['sdk'] = dart_version
        
        # Update dependencies
        dependencies = self.get_all_dependencies()
        for dep_name, dep_version in dependencies.items():
            if dep_name in pubspec.get('dependencies', {}):
                if dep_version != 'sdk':
                    pubspec['dependencies'][dep_name] = dep_version
        
        # Update dev dependencies
        dev_deps = self.versions.get('dev_dependencies', {})
        for dep_name, info in dev_deps.items():
            if dep_name in pubspec.get('dev_dependencies', {}):
                version = info.get('version') if isinstance(info, dict) else info
                if version != 'sdk':
                    pubspec['dev_dependencies'][dep_name] = version
        
        # Write back to pubspec.yaml
        with open(pubspec_path, 'w') as f:
            yaml.dump(pubspec, f, default_flow_style=False, sort_keys=False)
        
        print("✓ Synced versions to pubspec.yaml")
        return True

    def generate_env_file(self, output_file='.env.versions'):
        """Generate environment file for CI/CD"""
        env_content = []
        env_content.append("# Auto-generated from versions.yaml")
        env_content.append(f"FLUTTER_VERSION={self.get('sdk.flutter')}")
        env_content.append(f"DART_VERSION={self.get('sdk.dart')}")
        env_content.append(f"PROJECT_VERSION={self.get('project.version')}")
        env_content.append(f"BUILD_NUMBER={self.get('project.build_number')}")
        env_content.append(f"NODE_VERSION={self.get('tools.node')}")
        env_content.append(f"GRADLE_VERSION={self.get('tools.gradle')}")
        env_content.append(f"KOTLIN_VERSION={self.get('tools.kotlin')}")
        env_content.append(f"WEB_RENDERER={self.get('web.renderer')}")
        
        env_path = self.root_dir / output_file
        with open(env_path, 'w') as f:
            f.write('\n'.join(env_content))
        
        print(f"✓ Generated environment file: {output_file}")
        return True

    def print_versions(self):
        """Print all versions in a readable format"""
        print("\n=== Project Versions ===\n")
        
        sections = [
            ('Project', 'project'),
            ('SDK', 'sdk'),
            ('Tools', 'tools'),
            ('Dependencies', 'dependencies'),
            ('Dev Dependencies', 'dev_dependencies'),
            ('GitHub Actions', 'github_actions'),
            ('Web Config', 'web'),
            ('Android', 'android'),
            ('iOS', 'ios'),
        ]
        
        for title, key in sections:
            data = self.versions.get(key)
            if data:
                print(f"\n{title}:")
                self._print_dict(data, indent=2)

    def _print_dict(self, data, indent=0):
        """Recursively print dictionary"""
        prefix = ' ' * indent
        for key, value in data.items():
            if isinstance(value, dict):
                print(f"{prefix}{key}:")
                self._print_dict(value, indent + 2)
            else:
                print(f"{prefix}{key}: {value}")


def main():
    if len(sys.argv) < 2:
        print("Usage: python scripts/version_manager.py [command] [args]")
        print("\nCommands:")
        print("  get <key>           - Get a specific version (e.g., sdk.flutter)")
        print("  sync-flutter        - Sync Flutter version to .flutter-version")
        print("  sync-pubspec        - Sync versions to pubspec.yaml")
        print("  generate-env        - Generate .env.versions file")
        print("  print               - Print all versions")
        print("  dependency <name>   - Get dependency version")
        sys.exit(1)
    
    command = sys.argv[1]
    manager = VersionManager()
    
    try:
        if command == 'get':
            if len(sys.argv) < 3:
                print("Error: Please provide a key path")
                sys.exit(1)
            value = manager.get(sys.argv[2])
            if value is not None:
                print(value)
            else:
                print(f"Key not found: {sys.argv[2]}", file=sys.stderr)
                sys.exit(1)
        
        elif command == 'sync-flutter':
            manager.sync_flutter_version()
        
        elif command == 'sync-pubspec':
            manager.sync_pubspec()
        
        elif command == 'generate-env':
            manager.generate_env_file()
        
        elif command == 'print':
            manager.print_versions()
        
        elif command == 'dependency':
            if len(sys.argv) < 3:
                print("Error: Please provide a dependency name")
                sys.exit(1)
            version = manager.get_dependency_version(sys.argv[2])
            if version:
                print(version)
            else:
                print(f"Dependency not found: {sys.argv[2]}", file=sys.stderr)
                sys.exit(1)
        
        else:
            print(f"Unknown command: {command}")
            sys.exit(1)
    
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
