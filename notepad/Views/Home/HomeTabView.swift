import SwiftUI

struct Note: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let color: Color
    let date: Date
    var isCompleted: Bool = false
}

struct HomeTabView: View {
    @State private var notes: [Note] = [
        Note(title: "Belanja", content: "Beli telur, susu, roti", color: .yellow, date: Date()),
        Note(title: "Meeting", content: "Zoom jam 10 pagi", color: .green, date: Date().addingTimeInterval(-3600)),
        Note(title: "Ide App", content: "Buat aplikasi notepad dengan SwiftUI", color: .blue, date: Date().addingTimeInterval(-7200))
    ]
    @State private var selectedNoteID: UUID? = nil
    
    private var greeting: String {
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        let wib = TimeZone(identifier: "Asia/Jakarta")!
        let hour = calendar.component(.hour, from: now.addingTimeInterval(TimeInterval(wib.secondsFromGMT(for: now) - TimeZone.current.secondsFromGMT(for: now))))
        switch hour {
        case 4..<11: return "Selamat pagi, Georgia!"
        case 11..<15: return "Selamat siang, Georgia!"
        case 15..<18: return "Selamat sore, Georgia!"
        default: return "Selamat malam, Georgia!"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GreetingHeaderView(greeting: greeting)
            if notes.isEmpty {
                EmptyNotesView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(notes.indices, id: \.self) { idx in
                            NoteCardView(
                                note: $notes[idx],
                                isSelected: selectedNoteID == notes[idx].id,
                                onTap: {
                                    if !notes[idx].isCompleted {
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                            selectedNoteID = selectedNoteID == notes[idx].id ? nil : notes[idx].id
                                        }
                                    }
                                },
                                onComplete: {
                                    notes[idx].isCompleted = true
                                    selectedNoteID = nil
                                }
                            )
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

private struct GreetingHeaderView: View {
    let greeting: String
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "sun.max.fill")
                .font(.system(size: 32))
                .foregroundColor(.orange)
            VStack(alignment: .leading, spacing: 2) {
                Text(greeting)
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Semoga harimu menyenangkan!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top, 32)
        .padding(.horizontal)
    }
}

private struct EmptyNotesView: View {
    var body: some View {
        Spacer()
        VStack(spacing: 16) {
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.3))
            Text("Belum ada catatan.")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        Spacer()
    }
}

private struct NoteCardView: View {
    @Binding var note: Note
    var isSelected: Bool
    var onTap: () -> Void
    var onComplete: () -> Void
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center) {
                    Text(note.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .strikethrough(note.isCompleted, color: .gray)
                    Spacer()
                    TimeBadge(date: note.date)
                }
                Text(note.content)
                    .font(.body)
                    .foregroundColor(.primary)
                    .strikethrough(note.isCompleted, color: .gray)
                if isSelected && !note.isCompleted {
                    HStack(spacing: 16) {
                        Button(action: onComplete) {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                                Text("Completed")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.85))
                            .cornerRadius(16)
                        }
                        Button(action: {}) {
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                                .padding(8)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                        }
                        Button(action: {}) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .padding(8)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 8)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.vertical, isSelected ? 24 : 16)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(note.color.opacity(0.25))
                    .shadow(color: note.color.opacity(0.18), radius: 8, x: 0, y: 4)
            )
            .opacity(note.isCompleted ? 0.4 : 1.0)
            .overlay(
                note.isCompleted ?
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.green.opacity(0.7))
                        Spacer()
                    }
                } : nil
            )
            .onTapGesture { onTap() }
        }
        .padding(.horizontal)
    }
}

private struct TimeBadge: View {
    let date: Date
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "clock")
                .font(.caption)
                .foregroundColor(.gray)
            Text(date.formattedWIBTime)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color(.systemGray5))
                .clipShape(Capsule())
        }
    }
}

private extension Date {
    var formattedWIBTime: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Jakarta")
        formatter.dateFormat = "HH:mm 'WIB'"
        return formatter.string(from: self)
    }
}
